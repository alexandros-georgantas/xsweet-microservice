const { startServer, boss } = require('@coko/server')
const {
  DOCXToHTMLAsyncHandler,
  DOCXToHTMLAndSplitAsyncHandler,
} = require('./api/useCase')

const {
  DOCX_TO_HTML_AND_SPLIT_JOB,
  DOCX_TO_HTML_JOB,
} = require('./api/constants')

const init = async () => {
  startServer().then(async () => {
    boss.subscribe(DOCX_TO_HTML_JOB, async job => {
      const { data } = job
      const {
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
      } = data

      const responseParams = {
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
      }

      return DOCXToHTMLAsyncHandler(filePath, responseParams)
    })

    boss.subscribe(DOCX_TO_HTML_AND_SPLIT_JOB, async job => {
      const { data } = job

      const {
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        responseToken,
      } = data

      const responseParams = {
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        responseToken,
      }
      return DOCXToHTMLAndSplitAsyncHandler(filePath, responseParams)
    })
  })
}

init()
