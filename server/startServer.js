const { startServer, boss, logger } = require('@coko/server')
const {
  DOCXToHTMLAsyncHandler,
  DOCXToHTMLAndSplitAsyncHandler,
} = require('./api/useCase')

const {
  DOCX_TO_HTML_AND_SPLIT_JOB,
  DOCX_TO_HTML_JOB,
  MICROSERVICE_NAME,
} = require('./api/constants')

const init = async () => {
  logger.info(`${MICROSERVICE_NAME} server: about to initialize job queues`)
  startServer().then(async () => {
    boss.subscribe(DOCX_TO_HTML_JOB, async job => {
      const { data } = job
      const {
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      } = data

      const responseParams = {
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        objectId,
        responseToken,
      }

      return DOCXToHTMLAsyncHandler(filePath, responseParams)
    })
    logger.info(
      `${MICROSERVICE_NAME} server: queue ${DOCX_TO_HTML_JOB} registered`,
    )

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
    logger.info(
      `${MICROSERVICE_NAME} server: queue ${DOCX_TO_HTML_AND_SPLIT_JOB} registered`,
    )
  })
}

init()
