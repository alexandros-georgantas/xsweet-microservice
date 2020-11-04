const docxToHTMLEndpoint = require('./api')

module.exports = {
  server: () => app => docxToHTMLEndpoint(app),
}
