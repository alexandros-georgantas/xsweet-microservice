const { startServer, boss } = require('@coko/server')
const { queueHandler } = require('./api/helpers')

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
      return queueHandler(
        filePath,
        callbackURL,
        serviceCredentialId,
        serviceCallbackTokenId,
        bookComponentId,
        responseToken,
      )
    })
  })
}

init()
