const { boss } = require('@coko/server')
const { authenticate } = require('@coko/service-auth')

const { uploadHandler } = require('./helpers')

const docxToHTML = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ msg: req.fileValidationError })
    }
    if (!req.file) {
      return res.status(400).json({ msg: 'docx file is not included' })
    }

    const {
      serviceCredentialId,
      serviceCallbackTokenId,
      bookComponentId,
      responseToken,
      callbackURL,
    } = req.body
    const { path: filePath } = req.file

    await boss.publish('xsweet-conversion', {
      filePath,
      callbackURL,
      serviceCredentialId,
      serviceCallbackTokenId,
      bookComponentId,
      responseToken,
    })

    return res.status(200).json({
      msg: 'ok',
    })
  } catch (e) {
    return res.status(500).json({ msg: e.toString() })
  }
}

const xSweetServiceBackend = app => {
  app.post('/api/docxToHTML', authenticate, uploadHandler, docxToHTML)
}

module.exports = xSweetServiceBackend
