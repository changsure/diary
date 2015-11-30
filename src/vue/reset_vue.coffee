Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


ResetVue = Vue.extend({
  template: require('../template/reset.html')

  ready:()->
    $("#reset_div").css('padding-top',window.innerHeight*0.3)
    $(window).on('resize',()->
      $("#reset_div").css('padding-top',window.innerHeight*0.3)
    )

  methods:
    removeError:()->
      $("#form_password").removeClass("has-error")
      $("#form_password_repeat").removeClass("has-error")

    resetPass:()->
      if(!this.valid())
        return

      $("#icon_doing").removeClass("hidden")
      newPass = encryptUtil.sha1Hash(this.$data.password)
      exchangeService.resetPassword(this.$data.resetToken,newPass,(err)=>
        $("#icon_doing").addClass("hidden")
        if(err?)
          this.$set('message',err.errorMessage)
        else
          this.$set('message','Your password have been updated!<br> 您的密码已更新！')
      )

    valid:()->
      isValid = true

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

module.exports = ResetVue