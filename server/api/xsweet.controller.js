const tmp = require('tmp-promise')
const fs = require('fs-extra')
const path = require('path')
const { exec, execFile } = require('child_process')
const cheerio = require('cheerio')
const { authenticate } = require('@coko/service-auth')

const { uploadHandler, readFile, writeFile } = require('./helpers')

const imageCleaner = html => {
  const $ = cheerio.load(html)
  $('img[src]').each((i, elem) => {
    const $elem = $(elem)
    $elem.remove()
  })
  return $.html()
}

const docxToHTML = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ msg: req.fileValidationError })
    }
    if (!req.file) {
      return res.status(400).json({ msg: 'docx file is not included' })
    }
    const { path: filePath } = req.file

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

    await cleanup()
    await fs.remove(filePath)

    return res.status(200).json({
      html: cleaned,
    })
  } catch (e) {
    return res.status(500).json({ msg: e.toString() })
  }
}

const xSweetServiceBackend = app => {
  app.post('/api/docxToHTML', authenticate, uploadHandler, docxToHTML)
}

module.exports = xSweetServiceBackend
