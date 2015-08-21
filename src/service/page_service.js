// Generated by CoffeeScript 1.9.2
var checkAndRefreshLocalStorage, config, exchangeService, myutils, pageService;

config = require('./../config');

exchangeService = require('./exchange_service');

myutils = require('./../util/myutils');

checkAndRefreshLocalStorage = function(callback) {
  if ((localStorage.getItem('oceanContext') != null)) {
    window.oceanContext = JSON.parse(localStorage.getItem('oceanContext'));
    return callback();
  } else {
    return exchangeService.fetchOceanContext(null, function(err) {
      if ((err != null)) {
        return myutils.showErrorNoticeWindow(err.errorMessage);
      } else {
        return callback();
      }
    });
  }
};

pageService = {
  checkAndRefreshLocalStorage: checkAndRefreshLocalStorage
};

module.exports = pageService;