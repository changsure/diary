Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


SignUpVue = Vue.extend({
  template: require('../template/signup.html')
  methods:
    signUp:()->
      if(this.$data.password != this.$data.passwordRepeat)
        alert('Two password not match!')
        return

      user =
        email: this.$data.email
        accountName:this.$data.email
        displayName:this.$data.email
        password: encryptUtil.sha1Hash(this.$data.password)
        remember: true
      exchangeService.registerAccount(user,(err)->
        if(err?)
          alert(err.errorMessage)
        else
          window.location = config.siteAddress + '/#/login'
      )

})

module.exports = SignUpVue