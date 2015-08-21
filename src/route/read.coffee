config = require('../config')
ReadVue = require('./../vue/read_vue')
exchangeService = require('./../service/exchange_service')

module.exports = ()->

  if(!window.oceanContext.userInfo.login)
    window.location = config.siteAddress + '/#/login'
    return


  criteria =
    createTime:
      $lte:new Date().getTime()
  rowDes =
    limit: 1
    sort:
      createTime:-1


  exchangeService.queryDiary(criteria,null,rowDes,(err,records)->
    if(records?&&records[0]?)
      diary = records[0]
      window.recentDiaryDate = diary.date
      diary.pass = null
    else
      diary =
        _id:null
        date:null
        content:''
        pass:null
        passCheck:null

    new ReadVue(
      el:config.domIds.main
      data:diary
    )

  )
