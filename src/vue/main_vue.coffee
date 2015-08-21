Vue = require('vue')
$= window.$
exchangeService = require('./../service/exchange_service')
pageService = require('./../service/page_service')
myutils = require('./../util/myutils')
config = require('./../config')


MainVue = Vue.extend({
  template: require('../template/main.html')
  beforeCompile:()->

  ready:()->

  methods:

    logout:()->
      localStorage.removeItem('oceanContext')
      window.oceanContext = null
      window.location = config.siteAddress


})

module.exports = MainVue