const tmp = require('tmp-promise')
const fs = require('fs-extra')
const cheerio = require('cheerio')
const { exec, execFile } = require('child_process')
const axios = require('axios')
const path = require('path')

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

    const html = await readFile(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
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
