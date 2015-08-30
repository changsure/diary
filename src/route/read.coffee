config = require('../config')
ReadVue = require('./../vue/read_vue')
exchangeService = require('./../service/exchange_service')
async = require('async')

module.exports = ()->

  if(!window.oceanContext.userInfo.login)
    window.location = config.siteAddress + '/#/login'
    return


  async.waterfall(
    [
      (flowCallBack)->
        rowDes =
          limit: 1
          sort:
            createTime:-1
        exchangeService.queryDiary(null,null,rowDes,(err,records)->
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

          flowCallBack(err,diary)
        )
    ,
      (diary,flowCallBack)->
        rowDes =
          limit: 1
          sort:
            createTime:1
        exchangeService.queryDiary(null,'date',rowDes,(err,records)->
          if(records?&&records[0]?)
            window.earliestDiaryDate = records[0].date

          flowCallBack(err,diary)
        )
    ]
  ,
    (err,diary)->
      if(err?)
        alert(err.errorMessage)
      else
        new ReadVue(
          el:config.domIds.main
          data:diary
        )

  )
