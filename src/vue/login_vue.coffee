Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


LoginVue = Vue.extend({
  template: require('../template/login.html')
  methods:
    signIn:()->
      user =
        email: this.$data.email
        accountName:this.$data.email
        displayName:this.$data.email
        password: encryptUtil.sha1Hash(this.$data.password)
        remember: true

      exchangeService.loginAccount(user,(err,endToken)->
        if(err?)
          alert(err.errorMessage)
        else
          exchangeService.fetchOceanContext(endToken,()->
            window.location = config.siteAddress + '/#/main'
          )
      )

})

module.exports = LoginVue