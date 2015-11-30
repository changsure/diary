config = require('../config')
ResetPassVue = require('./../vue/reset_vue')

module.exports = (resetToken)->

  new ResetPassVue(
    el:config.domIds.main
    data:{resetToken:resetToken}
  )