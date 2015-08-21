config = require('../config')
LoginVue = require('./../vue/login_vue')

module.exports = ()->

  new LoginVue(
    el:config.domIds.main
  )