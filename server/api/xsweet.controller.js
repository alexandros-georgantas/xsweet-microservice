const { boss } = require('@coko/server')
const { authenticate } = require('@coko/service-auth')

const { uploadHandler } = require('./helpers')

const docxToHTMLAsyncHandler = async (req, res) => {
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

const convertAndSplitAsyncHandler = async (req, res) => {
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
      responseToken,
      callbackURL,
    } = req.body
    const { path: filePath } = req.file

    await boss.publish('xsweet-convert-and-split', {
      filePath,
      callbackURL,
      serviceCredentialId,
      serviceCallbackTokenId,
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
  app.post(
    '/api/v1/async/docxToHTML',
    authenticate,
    uploadHandler,
    docxToHTMLAsyncHandler,
  )
  app.post(
    '/api/v1/async/convertAndSplit',
    authenticate,
    uploadHandler,
    convertAndSplitAsyncHandler,
  )
  app.post('/api/v1/sync/docxToHTML', authenticate, uploadHandler, docxToHTML)
  app.post(
    '/api/v1/sync/convertAndSplit',
    authenticate,
    uploadHandler,
    convertAndSplit,
  )
}

module.exports = xSweetServiceBackend
