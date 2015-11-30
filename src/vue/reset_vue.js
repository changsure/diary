// Generated by CoffeeScript 1.9.2
var $, ResetVue, Vue, config, encryptUtil, exchangeService, myutils, pageService;

Vue = require('vue');

$ = window.$;

config = require('../config');

exchangeService = require('./../service/exchange_service');

pageService = require('./../service/page_service');

myutils = require('./../util/myutils');

encryptUtil = require('./../util/encrypt_util');

ResetVue = Vue.extend({
  template: require('../template/reset.html'),
  ready: function() {
    $("#reset_div").css('padding-top', window.innerHeight * 0.3);
    return $(window).on('resize', function() {
      return $("#reset_div").css('padding-top', window.innerHeight * 0.3);
    });
  },
  methods: {
    removeError: function() {
      $("#form_password").removeClass("has-error");
      return $("#form_password_repeat").removeClass("has-error");
    },
    resetPass: function() {
      var newPass;
      if (!this.valid()) {
        return;
      }
      $("#icon_doing").removeClass("hidden");
      newPass = encryptUtil.sha1Hash(this.$data.password);
      return exchangeService.resetPassword(this.$data.resetToken, newPass, (function(_this) {
        return function(err) {
          $("#icon_doing").addClass("hidden");
          if ((err != null)) {
            return _this.$set('message', err.errorMessage);
          } else {
            return _this.$set('message', 'Your password have been updated!<br> 您的密码已更新！');
          }
        };
      })(this));
    },
    valid: function() {
      var isValid;
      isValid = true;
      if (this.$data.password === '') {
        $("#form_password").addClass("has-error");
        isValid = false;
      }
      if (this.$data.passwordRepeat === '') {
        $("#form_password_repeat").addClass("has-error");
        isValid = false;
      }
      if (this.$data.password !== this.$data.passwordRepeat) {
        $("#form_password").addClass("has-error");
        $("#form_password_repeat").addClass("has-error");
        isValid = false;
      }
      return isValid;
    }
  }
});

module.exports = ResetVue;
