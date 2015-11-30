config = require('../config')
ForgetVue = require('./../vue/forget_vue')

module.exports = ()->

  new ForgetVue(
    el:config.domIds.main
  )