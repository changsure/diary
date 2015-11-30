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
    $("#login_div").css('padding-top',window.innerHeight*0.3)
    $(window).on('resize',()->
      $("#login_div").css('padding-top',window.innerHeight*0.3)
    )

    this.bindInit()

  methods:
    bindInit:()->
      # bind enter to pass
      $("#form_password").keydown((e)=>
        if(e.which == 13 || e.keyCode == 13)
          this.signIn()
      )

    signIn:()->
      if(!this.valid())
        return
      $("#icon_doing").removeClass("hidden")
      user =
        email: this.$data.email
        accountName:this.$data.email
        displayName:this.$data.email
        password: encryptUtil.sha1Hash(this.$data.password)
        rememberMe: true

      exchangeService.loginAccount(user,(err,endToken)->
        $("#icon_doing").addClass("hidden")
        if(err?)
          if(err.errCode == 'user.accountOrPasswordNotRight')
            $("#form_email").addClass("has-error")
            $("#form_password").addClass("has-error")
            $("#forget_div").removeClass("hidden")
          else
            alert(err.errorMessage)
        else
          exchangeService.fetchOceanContext(endToken,()->
            window.location = config.siteAddress + '/#/main'
          )
      )

    valid:()->
      isValid = true

      emailReg = ///\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$///
      if(!this.$data.email? || this.$data.email == '')
        $("#form_email").addClass("has-error")
        isValid = false
      else if(!emailReg.test(this.$data.email))
        $("#form_email").addClass("has-error")
        isValid = false

      if(this.$data.password=='')
        $("#form_password").addClass("has-error")
        isValid = false

      return isValid
    removeError:()->
      $("#form_email").removeClass("has-error")
      $("#form_password").removeClass("has-error")
})

module.exports = LoginVue