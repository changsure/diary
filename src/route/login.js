// Generated by CoffeeScript 1.9.2
var LoginVue, config;

config = require('../config');

LoginVue = require('./../vue/login_vue');

module.exports = function() {
  return new LoginVue({
    el: config.domIds.main
  });
};