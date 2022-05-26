const { boss } = require('@coko/server')

const {
  DOCXToHTMLSyncHandler,
  DOCXToHTMLAndSplitSyncHandler,
} = require('./useCase')
const { DOCX_TO_HTML_AND_SPLIT_JOB, DOCX_TO_HTML_JOB } = require('./constants')

const DOCXToHTMLAsyncController = async (req, res) => {
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

    await boss.publish(DOCX_TO_HTML_JOB, {
      filePath,
      callbackURL,
      serviceCredentialId,
      serviceCallbackTokenId,
      bookComponentId,
      responseToken,
    })

    return res.status(200).json({
      msg: 'ok',
      error: undefined,
    })
  } catch (e) {
    return res.status(500).json({ error: e.toString(), msg: undefined })
  }
}

const DOCXToHTMLSyncController = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ msg: req.fileValidationError })
    }
    if (!req.file) {
      return res.status(400).json({ msg: 'docx file is not included' })
    }

    const { path: filePath } = req.file

    const htmlContent = await DOCXToHTMLSyncHandler(filePath)

    return res.status(200).json({
      html: htmlContent,
      error: undefined,
    })
  } catch (e) {
    return res.status(500).json({ html: undefined, error: e.toString() })
  }
}

const DOCXToHTMLAndSplitAsyncController = async (req, res) => {
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

    await boss.publish(DOCX_TO_HTML_AND_SPLIT_JOB, {
      filePath,
      callbackURL,
      serviceCredentialId,
      serviceCallbackTokenId,
      responseToken,
    })

    return res.status(200).json({
      msg: 'ok',
      error: undefined,
    })
  } catch (e) {
    return res.status(500).json({ error: e.toString(), msg: undefined })
  }
}

const DOCXToHTMLAndSplitSyncController = async (req, res) => {
  try {
    if (req.fileValidationError) {
      return res.status(400).json({ msg: req.fileValidationError })
    }
    if (!req.file) {
      return res.status(400).json({ msg: 'docx file is not included' })
    }

    const { path: filePath } = req.file
    const chapters = await DOCXToHTMLAndSplitSyncHandler(filePath)

    return res.status(200).json({
      chapters,
      error: undefined,
    })
  } catch (e) {
    return res.status(500).json({ chapters: [], error: e.toString() })
  }
}

module.exports = {
  DOCXToHTMLAsyncController,
  DOCXToHTMLAndSplitAsyncController,
  DOCXToHTMLSyncController,
  DOCXToHTMLAndSplitSyncController,
}
