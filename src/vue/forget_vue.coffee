Vue = require('vue')
$ = window.$
config = require('../config')
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')


ForgetVue = Vue.extend({
  template: require('../template/forget.html')

  ready:()->
    $("#forget_div").css('padding-top',window.innerHeight*0.3)
    $(window).on('resize',()->
      $("#forget_div").css('padding-top',window.innerHeight*0.3)
    )

  methods:
    removeError:()->
      $("#form_email").removeClass("has-error")

    forget:()->
      if(!this.valid())
        return

      $("#icon_doing").removeClass("hidden")
      user =
        accountName:this.$data.email
      exchangeService.forgetPassword(user,(err)=>
        $("#icon_doing").addClass("hidden")
        if(err?)
          this.$set('message',err.errorMessage)
        else
          this.$set('message','Reset confirm email already send to your email address!<br> 重置密码邮件已经发至您的邮箱！')
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

      return isValid
})

module.exports = ForgetVue