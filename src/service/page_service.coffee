config = require('./../config')

exchangeService = require('./exchange_service')

myutils = require('./../util/myutils')

fetchAnonymousContext = (callback)->
  exchangeService.fetchOceanContext(null, (err)->
    if(err?)
      myutils.showErrorNoticeWindow(err.errorMessage)
    else
      callback()
  )

checkAndRefreshLocalStorage = (callback)->
  if(localStorage.getItem('oceanContext')? )
    oceanContext = JSON.parse(localStorage.getItem('oceanContext'))
    if(new Date().getTime() > oceanContext.expireTime)
      localStorage.removeItem('oceanContext')
      fetchAnonymousContext(callback)
    else
      window.oceanContext = JSON.parse(localStorage.getItem('oceanContext'))
      callback()
  else
    fetchAnonymousContext(callback)

pageService = {
  checkAndRefreshLocalStorage: checkAndRefreshLocalStorage
}

module.exports = pageService
