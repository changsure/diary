Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


LoginVue = Vue.extend({
  template: require('../template/login.html')

  ready:()->
    # bind enter to pass
    $("#input_password").keydown((e)=>
      key = e.which
      if(key == 13)
        this.signIn()
    )

  methods:
    signIn:()->
      $("#icon_doing").removeClass("hidden")
      user =
        email: this.$data.email
        accountName:this.$data.email
        displayName:this.$data.email
        password: encryptUtil.sha1Hash(this.$data.password)
        remember: true

      exchangeService.loginAccount(user,(err,endToken)->
        $("#icon_doing").addClass("hidden")
        if(err?)
          alert(err.errorMessage)
        else
          exchangeService.fetchOceanContext(endToken,()->
            window.location = config.siteAddress + '/#/main'
          )
      )

})

module.exports = LoginVue