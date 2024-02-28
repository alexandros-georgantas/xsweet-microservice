const { logger } = require('@coko/server')
const tmp = require('tmp-promise')
const fs = require('fs-extra')
const cheerio = require('cheerio')
const { execFile, spawn } = require('child_process')
const axios = require('axios')
const path = require('path')
const { MICROSERVICE_NAME } = require('./constants')
const { reintegrateMathType } = require('./mathtype')
const {
  readFile,
  writeFile,
  imagesHandler,
  contentFixer,
  mathFixer,
} = require('./helpers')

const checkForFiles = async (startPath, extension) => {
  // This returns a list of paths to WMF files. If there are no WMF files, it returns an empty list.
  const wmfList = []
  if (!fs.existsSync(startPath)) {
    // logger.info('No word/media folder!')
    return []
  }

  const files = fs.readdirSync(startPath)
  for (let i = 0; i < files.length; i += 1) {
    const filename = path.join(startPath, files[i])
    if (filename.endsWith(extension)) {
      // logger.info('WMF file found! ', filename)
      wmfList.push(filename)
    }
  }
  return wmfList
}

const DOCXToHTMLSyncHandler = async (filePath, useMathCleaner = undefined) => {
  // this is what's used by Kotahi
  let cleaner

  try {
    const { path: tmpDir, cleanup } = await tmp.dir({
      prefix: '_conversion-',
      unsafeCleanup: true,
      dir: process.cwd(),
    })
    cleaner = cleanup
    const buf = await readFile(filePath)

    await writeFile(path.join(tmpDir, path.basename(filePath)), buf)
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): extracts docx's components`,
    )

    await new Promise((resolve, reject) => {
      execFile(
        'unzip',
        ['-o', `${tmpDir}/${path.basename(filePath)}`, '-d', tmpDir],
        (error, stdout, stderr) => {
          if (error) {
            reject(error)
          }
          resolve(stdout)
        },
      )
    })
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): executes execute_chain.sh script`,
    )

    await new Promise((resolve, reject) => {
      const xsweet = spawn(
        `sh ${path.resolve(
          __dirname,
          '..',
          '..',
          'scripts',
          'execute_chain.sh',
        )} ${tmpDir}`,
        [],
        { shell: true },
      )
      xsweet.stdout.on('data', data => {
        logger.info(`stdout: ${data}`)
      })

      xsweet.stderr.on('data', data => {
        logger.info(`stderr: ${data}`)
      })

      xsweet.on('error', error => {
        if (error) {
          reject(error)
        }
      })

      xsweet.on('close', code => {
        logger.info(`child process exited with code ${code}`)
        resolve(code)
      })
    })

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): reads produces HTML file`,
    )
    let html = await readFile(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
    )

    // At this point, look in tmpDir/word/media to see if there are any WMF files there. If so . . .
    logger.info('Looking for WMF files!')
    const wmfFilesFound = await checkForFiles(`${tmpDir}/word/media/`, '.wmf')
    if (wmfFilesFound.length > 0) {
      logger.info('WMF files found, converting...')
      await new Promise((resolve, reject) => {
        const wmfProcess = spawn(
          `sh ${path.resolve(
            __dirname,
            '..',
            '..',
            'scripts/mathtype',
            'processwmffiles.sh',
          )} ${tmpDir}`,
          [],
          { shell: true },
        )
        wmfProcess.stdout.on('data', data => {
          logger.info(`stdout: ${data}`)
        })

        wmfProcess.stderr.on('data', data => {
          logger.info(`stderr: ${data}`)
        })

        wmfProcess.on('error', error => {
          if (error) {
            reject(error)
          }
        })

        wmfProcess.on('close', code => {
          logger.info(`child process exited with code ${code}`)
          resolve(code)
        })
      })
      // Check if we have .xml files in the tmpDir/word/media/tex folder
      // If so, send them to a function that reinserts them.
      const texFilesFound = await checkForFiles(
        `${tmpDir}/word/media/tex/`,
        '.xml',
      )
      if (texFilesFound.length > 0) {
        logger.info('TeX files generated!')
        html = await reintegrateMathType(html, texFilesFound)
      }
    }

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): cleans HTML file from images and unnecessary attributes`,
    )

    const cleanedFromImages = imagesHandler(html)
    const fixedContent = contentFixer(cleanedFromImages)
    const cleanedMath = useMathCleaner ? mathFixer(fixedContent) : fixedContent
    const passThroughWMF = cleanedMath
      .replaceAll('math@display', 'math-display')
      .replaceAll('math@inline', 'math-inline')
    return passThroughWMF
  } catch (e) {
    throw new Error(e)
  } finally {
    if (cleaner) {
      await cleaner()
    }
    await fs.remove(filePath)
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): removes tmp folders and docx file`,
    )
  }
}

const DOCXToHTMLAsyncHandler = async (
  filePath,
  responseParams,
  useMathCleaner = undefined,
) => {
  const {
    callbackURL,
    serviceCallbackTokenId,
    objectId,
    responseToken,
  } = responseParams
  try {
    const html = await DOCXToHTMLSyncHandler(filePath)

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAsyncHandler): returns the converted file back to its caller`,
    )

    const res = await axios({
      method: 'post',
      url: callbackURL,
      maxBodyLength: 104857600, // 100mb
      maxContentLength: 104857600, // 100mb
      data: {
        convertedContent: useMathCleaner ? mathFixer(html) : html,
        error: undefined,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      },
    })

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAsyncHandler): got response from caller ${res.data.msg}`,
    )
    return true
  } catch (e) {
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAsyncHandler): inform caller that something went wrong`,
    )
    logger.error(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAsyncHandler): ${e.message}`,
    )

    return axios({
      method: 'post',
      url: callbackURL,
      data: {
        convertedContent: undefined,
        error: e,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      },
    })
  }
}

const DOCXToHTMLAndSplitSyncHandler = async (
  filePath,
  useMathCleaner = undefined,
) => {
  let cleaner

  try {
    const buf = await readFile(filePath)
    const { path: tmpDir, cleanup } = await tmp.dir({
      prefix: '_conversion-',
      unsafeCleanup: true,
      dir: process.cwd(),
    })
    cleaner = cleanup
    await writeFile(path.join(tmpDir, path.basename(filePath)), buf)
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitSyncHandler): extracts docx's components`,
    )
    await new Promise((resolve, reject) => {
      execFile(
        'unzip',
        ['-o', `${tmpDir}/${path.basename(filePath)}`, '-d', tmpDir],
        (error, stdout, stderr) => {
          if (error) {
            reject(error)
          }
          resolve(stdout)
        },
      )
    })

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitSyncHandler): executes xsweet_splitter_execute_chain.sh script`,
    )

    await new Promise((resolve, reject) => {
      const xsweet = spawn(
        `sh ${path.resolve(
          __dirname,
          '..',
          '..',
          'scripts',
          'docx-splitter',
          'xsweet_splitter_execute_chain.sh', // or editoria_splitter_execute_chain.sh
        )} ${tmpDir}`,
        [],
        { shell: true },
      )
      xsweet.stdout.on('data', data => {
        logger.info(`stdout: ${data}`)
      })

      xsweet.stderr.on('data', data => {
        logger.info(`stderr: ${data}`)
      })

      xsweet.on('error', error => {
        if (error) {
          reject(error)
        }
      })

      xsweet.on('close', code => {
        logger.info(`child process exited with code ${code}`)
        resolve(code)
      })
    })

    const html = await readFile(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
    )

    const $ = cheerio.load(html)
    const chapters = []
    $('container').each((i, element) => {
      // const $elem = $(element).html()
      const chtml = `<container id='main'>${$(element).html()}</container>`
      const content = imagesHandler(chtml)
      chapters.push(useMathCleaner ? mathFixer(content) : content)
    })

    return chapters
  } catch (e) {
    throw new Error(e)
  } finally {
    if (cleaner) {
      await cleaner()
    }
    await fs.remove(filePath)
  }
}

const DOCXToHTMLAndSplitAsyncHandler = async (
  filePath,
  responseParams,
  useMathCleaner = undefined,
) => {
  const { callbackURL, serviceCallbackTokenId, responseToken } = responseParams
  try {
    const chapters = await DOCXToHTMLAndSplitSyncHandler(
      filePath,
      useMathCleaner,
    )

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitAsyncHandler): returns the converted file back to its caller`,
    )
    return axios({
      method: 'post',
      url: callbackURL,
      maxBodyLength: 104857600, // 100mb
      maxContentLength: 104857600, // 100mb
      data: {
        chapters,
        error: undefined,
        serviceCallbackTokenId,
        responseToken,
      },
    })
  } catch (e) {
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitAsyncHandler): inform caller that something went wrong`,
    )
    logger.error(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitAsyncHandler): ${e.message}`,
    )

    return axios({
      method: 'post',
      url: callbackURL,
      data: {
        convertedContent: undefined,
        error: e,
        serviceCallbackTokenId,
        responseToken,
      },
    })
  }
}

module.exports = {
  DOCXToHTMLAsyncHandler,
  DOCXToHTMLSyncHandler,
  DOCXToHTMLAndSplitAsyncHandler,
  DOCXToHTMLAndSplitSyncHandler,
}
