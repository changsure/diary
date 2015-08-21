config = require('../config')
MainVue = require('./../vue/main_vue')

module.exports = ()->

  if(!window.oceanContext.userInfo.login)
    window.location = config.siteAddress + '/#/login'
    return

  new MainVue(
    el:config.domIds.main
  )