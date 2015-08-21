config = require('./../config')

exchangeService = require('./exchange_service')

myutils = require('./../util/myutils')

checkAndRefreshLocalStorage = (callback)->
  if(localStorage.getItem('oceanContext')? )
    window.oceanContext = JSON.parse(localStorage.getItem('oceanContext'))
    callback()
  else
    exchangeService.fetchOceanContext(null, (err)->
      if(err?)
        myutils.showErrorNoticeWindow(err.errorMessage)
      else
        callback()
    )

pageService = {
  checkAndRefreshLocalStorage: checkAndRefreshLocalStorage
}

module.exports = pageService
