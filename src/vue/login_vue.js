// Generated by CoffeeScript 1.9.2
var $, LoginVue, Vue, config, encryptUtil, exchangeService, myutils, pageService;

Vue = require('vue');

$ = window.$;

config = require('../config');

exchangeService = require('./../service/exchange_service');

pageService = require('./../service/page_service');

myutils = require('./../util/myutils');

encryptUtil = require('./../util/encrypt_util');

LoginVue = Vue.extend({
  template: require('../template/login.html'),
  ready: function() {
    return $("#input_password").keydown((function(_this) {
      return function(e) {
        var key;
        key = e.which;
        if (key === 13) {
          return _this.signIn();
        }
      };
    })(this));
  },
  methods: {
    signIn: function() {
      var user;
      $("#icon_doing").removeClass("hidden");
      user = {
        email: this.$data.email,
        accountName: this.$data.email,
        displayName: this.$data.email,
        password: encryptUtil.sha1Hash(this.$data.password),
        remember: true
      };
      return exchangeService.loginAccount(user, function(err, endToken) {
        $("#icon_doing").addClass("hidden");
        if ((err != null)) {
          return alert(err.errorMessage);
        } else {
          return exchangeService.fetchOceanContext(endToken, function() {
            return window.location = config.siteAddress + '/#/main';
          });
        }
      });
    }
  }
});

module.exports = LoginVue;
