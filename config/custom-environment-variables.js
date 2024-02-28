module.exports = {
  'pubsweet-server': {
    secret: 'PUBSWEET_SECRET',
    db: {
      user: 'POSTGRES_USER',
      password: 'POSTGRES_PASSWORD',
      host: 'POSTGRES_HOST',
      database: 'POSTGRES_DB',
      port: 'POSTGRES_PORT',
    },
    host: 'SERVER_HOST',
    port: 'SERVER_PORT',
    protocol: 'SERVER_PROTOCOL',
  },
  clientID: 'CLIENT_ID',
  clientSecret: 'CLIENT_SECRET',
}
