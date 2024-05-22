const { environment } = require('@rails/webpacker')

environment.config.merge({
  node: {
    __dirname: true,
    __filename: true
  }
})

module.exports = environment
