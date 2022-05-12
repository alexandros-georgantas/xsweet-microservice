const { startServer, boss } = require('@coko/server')
const {
  queueHandlerConvert,
  queueHandlerConvertAndSplit,
} = require('./api/helpers')

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
      return queueHandlerConvert(
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
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
