config = {}
config.appKey = 'diary'
config.siteAddress = 'http://diary.lonetime.com'

config.apiResources =
  userRegister:()->
    return window.oceanContext.backServices.user.api + '/register'
  userLogin:()->
    return window.oceanContext.backServices.user.api + '/login'
  userUpdate:()->
    return window.oceanContext.backServices.user.api + '/update'
  getAnonymousOceanContext:()->
    return 'https://api.oceanclouds.com/v1.0/public/ocean_context/' + config.appKey
  getEndUserOceanContext:()->
    return 'https://api.oceanclouds.com/v1.0/end/ocean_context/' + config.appKey
  diaryCrudAddress:(_id,isQuery)->
    if(_id?)
      return window.oceanContext.backServices.crud.api + '/' + config.appKey + '/diary/' + _id
    else if(isQuery)
      return window.oceanContext.backServices.crud.api + '/' + config.appKey + '/diary/find/query'
    else
      return window.oceanContext.backServices.crud.api + '/' + config.appKey + '/diary'
config.domIds =
  main:'#main'

module.exports = config


