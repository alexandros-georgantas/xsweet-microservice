const { logger } = require('@coko/server')
const tmp = require('tmp-promise')
const fs = require('fs-extra')
const cheerio = require('cheerio')
const { exec, execFile } = require('child_process')
const axios = require('axios')
const path = require('path')
const { MICROSERVICE_NAME } = require('./constants')
const { readFile, writeFile, imageCleaner, contentFixer } = require('./helpers')

const DOCXToHTMLSyncHandler = async filePath => {
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
      exec(
        `sh ${path.resolve(
          __dirname,
          '..',
          '..',
          'scripts',
          'execute_chain.sh',
        )} ${tmpDir}`,
        (error, stdout, stderr) => {
          if (error) {
            reject(error)
          }
          resolve(stdout)
        },
      )
    })
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): reads produces HTML file`,
    )
    const html = await readFile(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
    )
    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLSyncHandler): cleans HTML file from images and unnecessary attributes`,
    )
    const cleanedFromImages = imageCleaner(html)
    const fixedContent = contentFixer(cleanedFromImages)

    return fixedContent
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

const DOCXToHTMLAsyncHandler = async (filepath, responseParams) => {
  const {
    callbackURL,
    serviceCredentialId,
    serviceCallbackTokenId,
    objectId,
    responseToken,
  } = responseParams
  try {
    const html = await DOCXToHTMLSyncHandler(filepath)

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAsyncHandler): returns the converted file back to its caller`,
    )

    return axios({
      method: 'post',
      url: `${callbackURL}/api/xsweet`,
      data: {
        convertedContent: html,
        error: undefined,
        serviceCredentialId,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      },
    })
  } catch (e) {
    return axios({
      method: 'post',
      url: `${callbackURL}/api/xsweet`,
      data: {
        convertedContent: undefined,
        error: e,
        serviceCredentialId,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      },
    })
  }
}

const DOCXToHTMLAndSplitSyncHandler = async filePath => {
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
      exec(
        `sh ${path.resolve(
          __dirname,
          '..',
          '..',
          'scripts',
          'docx-splitter',
          'xsweet_splitter_execute_chain.sh', // or editoria_splitter_execute_chain.sh
        )} ${tmpDir}`,
        (error, stdout, stderr) => {
          if (error) {
            reject(error)
          }
          resolve(stdout)
        },
      )
    })

    const html = await readFile(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
    )

    const $ = cheerio.load(html)
    const chapters = []
    $('container').each((i, element) => {
      const cleanedFromImages = imageCleaner(element)
      const fixedContent = contentFixer(cleanedFromImages)
      chapters.push(fixedContent)
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

const DOCXToHTMLAndSplitAsyncHandler = async (filePath, responseParams) => {
  const {
    callbackURL,
    serviceCredentialId,
    serviceCallbackTokenId,
    responseToken,
  } = responseParams
  try {
    const chapters = await DOCXToHTMLAndSplitSyncHandler(filePath)

    logger.info(
      `${MICROSERVICE_NAME} use-case(DOCXToHTMLAndSplitAsyncHandler): returns the converted file back to its caller`,
    )
    return axios({
      method: 'post',
      url: `${callbackURL}/api/xsweet`,
      data: {
        chapters,
        error: undefined,
        serviceCredentialId,
        serviceCallbackTokenId,
        responseToken,
      },
    })
  } catch (e) {
    return axios({
      method: 'post',
      url: `${callbackURL}/api/xsweet`,
      data: {
        convertedContent: undefined,
        error: e,
        serviceCredentialId,
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
