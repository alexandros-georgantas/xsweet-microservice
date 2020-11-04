const tmp = require('tmp-promise')
const fs = require('fs-extra')
const path = require('path')
const { execSync, execFileSync } = require('child_process')
// const logger = require('@pubsweet/logger')
const { authenticate } = require('@coko/service-auth')

const { uploadHandler } = require('./helpers')

// encode file to base64
const base64EncodeFile = originalPath =>
  fs.readFileSync(originalPath).toString('base64')

const imagesToBase64 = html => {
  // create array of the img elements in the HTML file
  const images = html.match(/<img src="file:.*?">/g)
  // create corresponding array of img paths
  const paths = images.map(el => el.slice(15, el.length - 2))

  // swap out img path elements with inline base64 picture elements
  paths.forEach((p, index) => {
    const ext = p.slice(p.lastIndexOf('.') + 1, p.length)
    const imageInBase64 = `<img src="data:image/${ext};base64,${base64EncodeFile(
      p,
    )}" />`
    html = html.replace(images[index], imageInBase64)
  })

  return html
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

    const buf = fs.readFileSync(filePath)

    const { path: tmpDir, cleanup } = await tmp.dir({
      prefix: '_conversion-',
      unsafeCleanup: true,
      dir: process.cwd(),
    })

    fs.writeFileSync(path.join(tmpDir, path.basename(filePath)), buf)
    execFileSync('unzip', [
      '-o',
      `${tmpDir}/${path.basename(filePath)}`,
      '-d',
      tmpDir,
    ])

    execSync(
      `sh ${path.resolve(
        __dirname,
        '..',
        '..',
        'scripts',
        'execute_chain.sh',
      )} ${tmpDir}`,
    )
    const html = fs.readFileSync(
      path.join(tmpDir, 'outputs', 'HTML5.html'),
      'utf8',
    )

    let processedHtml
    try {
      processedHtml = imagesToBase64(html)
    } catch (e) {
      processedHtml = html
    }

    await cleanup()
    await fs.remove(filePath)

    return res.status(200).json({
      html: processedHtml,
    })
  } catch (e) {
    throw new Error('Conversion error')
  }
}

const xSweetServiceBackend = app => {
  app.post('/api/docxToHTML', authenticate, uploadHandler, docxToHTML)
}

module.exports = xSweetServiceBackend
