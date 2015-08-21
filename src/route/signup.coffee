config = require('../config')
SignUpVue = require('./../vue/signup_vue')

module.exports = ()->

  new SignUpVue(
    el:config.domIds.main
  )