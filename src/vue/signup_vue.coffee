Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


SignUpVue = Vue.extend({
  template: require('../template/signup.html')

  ready:()->


  methods:
    removeError:()->
      $("#form_email").removeClass("has-error")
      $("#form_password").removeClass("has-error")
      $("#form_password_repeat").removeClass("has-error")

    signUp:()->
      if(!this.valid())
        return

      $("#icon_doing").removeClass("hidden")
      user =
        email: this.$data.email
        accountName:this.$data.email
        displayName:this.$data.email
        password: encryptUtil.sha1Hash(this.$data.password)
        remember: true
      exchangeService.registerAccount(user,(err)->
        $("#icon_doing").addClass("hidden")
        if(err?)
          if(err.errCode == 'user.alreadyExist')
            $("#form_email").addClass("has-error")
          else
            alert(err.errorMessage)
        else
          window.location = config.siteAddress + '/#/login'
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

      if(this.$data.passwordRepeat=='')
        $("#form_password_repeat").addClass("has-error")
        isValid = false

      if(this.$data.password != this.$data.passwordRepeat)
        $("#form_password").addClass("has-error")
        $("#form_password_repeat").addClass("has-error")
        isValid = false

      return isValid

})

module.exports = SignUpVue