// Generated by CoffeeScript 1.9.2
var SignUpVue, config;

config = require('../config');

SignUpVue = require('./../vue/signup_vue');

module.exports = function() {
  return new SignUpVue({
    el: config.domIds.main
  });
};
