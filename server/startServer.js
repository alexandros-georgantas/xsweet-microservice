const { startServer, boss } = require('@coko/server')
const { convertHandler, queueHandlerConvertAndSplit } = require('./api/helpers')

const init = async () => {
  startServer().then(async () => {
    boss.subscribe('xsweet-conversion', async job => {
      const { data } = job

      const {
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
      } = data
      return convertHandler(
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
        true,
      )
    })

    boss.subscribe('xsweet-convert-and-split', async job => {
      const { data } = job

      const {
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        responseToken,
      } = data
      return queueHandlerConvertAndSplit(
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        responseToken,
      )
    })
  })
}

init()
