const multer = require('multer')
const path = require('path')
const tmp = require('tmp-promise')
const fs = require('fs-extra')
const cheerio = require('cheerio')
const { exec, execFile } = require('child_process')
const axios = require('axios')

const imageCleaner = html => {
  const $ = cheerio.load(html)
  $('img[src]').each((i, elem) => {
    const $elem = $(elem)
    $elem.remove()
  })
  return $.html()
}

const contentFixer = html => {
  const $ = cheerio.load(html)
  $('p').each((i, elem) => {
    const $elem = $(elem)
    if (!$elem.attr('class')) {
      $elem.attr('class', 'paragraph')
    }
  })
  return $('container').html()
}

const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    await fs.ensureDir('temp/')
    return cb(null, 'temp/')
  },

  // By default, multer removes file extensions so let's add them back
  filename: (req, file, cb) =>
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`,
    ),
})

const fileFilter = (req, file, cb) => {
  // Accept docxs only
  if (!file.originalname.match(/\.(docx)$/)) {
    req.fileValidationError = 'Only docx files are allowed!'
    return cb(null, false)
  }
  return cb(null, true)
}
const uploadHandler = multer({ storage, fileFilter }).single('docx')

const readFile = (filePath, encoding = undefined) =>
  new Promise((resolve, reject) => {
    if (encoding) {
      fs.readFile(filePath, encoding, (err, data) => {
        if (err) {
          return reject(err)
        }
        return resolve(data)
      })
    } else {
      fs.readFile(filePath, (err, data) => {
        if (err) {
          return reject(err)
        }
        return resolve(data)
      })
    }
  })

const writeFile = (filePath, data) =>
  new Promise((resolve, reject) => {
    fs.writeFile(filePath, data, err => {
      if (err) {
        return reject(err)
      }
      return resolve(true)
    })
  })

const convertHandler = async (
  filePath,
  callbackURL,
  serviceCredentialId,
  serviceCallbackTokenId,
  bookComponentId,
  responseToken,
  async,
) => {
  try {
    const buf = await readFile(filePath)
    const { path: tmpDir, cleanup } = await tmp.dir({
      prefix: '_conversion-',
      unsafeCleanup: true,
      dir: process.cwd(),
    })

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

    const cleaned = imageCleaner(html)
    const fixed = contentFixer(cleaned)

    await cleanup()
    await fs.remove(filePath)

    if (async) {
      return axios({
        method: 'post',
        url: `${callbackURL}/api/xsweet`,
        data: {
          convertedContent: fixed,
          error: undefined,
          serviceCredentialId,
          serviceCallbackTokenId,
          bookComponentId,
          responseToken,
        },
      })
    }

    return fixed
  } catch (e) {
    await fs.remove(filePath)
    if (async) {
      return axios({
        method: 'post',
        url: `${callbackURL}/api/xsweet`,
        data: {
          convertedContent: undefined,
          error: e,
          serviceCredentialId,
          serviceCallbackTokenId,
          bookComponentId,
          responseToken,
        },
      })
    }
    return e
  }
}

const convertAndSplitHandler = async (
  filePath,
  callbackURL,
  serviceCredentialId,
  serviceCallbackTokenId,
  responseToken,
  async,
) => {
  try {
    const buf = await readFile(filePath)
    const { path: tmpDir, cleanup } = await tmp.dir({
      prefix: '_conversion-',
      unsafeCleanup: true,
      dir: process.cwd(),
    })

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
          'execute_chain.sh', // what should be executed here
        )} ${tmpDir}`,
        (error, stdout, stderr) => {
          if (error) {
            reject(error)
          }
          resolve(stdout)
        },
      )
    })

    // CHANGES HERE

    // changes here when the chain completes in order to populate the chapters array below
    // const html = await readFile(
    //   path.join(tmpDir, 'outputs', 'HTML5.html'),
    //   'utf8',
    // )
    // each chapter's HTML should be passed and cleaned
    // const cleaned = imageCleaner(html)
    // const fixed = contentFixer(cleaned)
    // then should be added in the array
    // const chapters = []

    await cleanup()
    await fs.remove(filePath)

    if (async) {
      return axios({
        method: 'post',
        url: `${callbackURL}/api/xsweet`,
        data: {
          // chapters,
          error: undefined,
          serviceCredentialId,
          serviceCallbackTokenId,
          responseToken,
        },
      })
    }
    return true
  } catch (e) {
    await fs.remove(filePath)
    if (async) {
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
    return e
  }
}

module.exports = {
  uploadHandler,
  readFile,
  writeFile,
  convertHandler,
  convertAndSplitHandler,
}
