const winston = require('winston')
const path = require('path')
/* eslint-disable import/extensions */
const components = require('./components')
/* eslint-enable import/extensions */

const logger = new winston.Logger({
  transports: [
    new winston.transports.Console({
      colorize: true,
      handleExceptions: true,
      humanReadableUnhandledException: true,
    }),
  ],
})

module.exports = {
  authsome: {
    mode: path.join(__dirname, 'authsome.js'),
  },

  publicKeys: ['pubsweet', 'pubsweet-server'],
  pubsweet: {
    components,
  },
  teams: {
    global: {
      admin: {
        displayName: 'Admin',
        role: 'admin',
      },
    },
    nonGlobal: {},
  },
  'pubsweet-server': {
    db: {},
    logger,
    useJobQueue: true,
    port: 3000,
    protocol: 'http',
    host: 'localhost',
    useGraphQLServer: false,
    pool: { min: 0, max: 10, idleTimeoutMillis: 1000 },
  },
}
