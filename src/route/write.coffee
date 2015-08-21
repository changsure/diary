dateFormat = require('dateformat')

config = require('../config')
exchangeService = require('../service/exchange_service')
WriteVue = require('./../vue/write_vue')

module.exports = ()->

  if(!window.oceanContext.userInfo.login)
    window.location = config.siteAddress + '/#/login'
    return


  today = dateFormat(new Date(), 'yyyy-mm-dd')

  criteria =
    date:today
  exchangeService.queryDiary(criteria,null,null,(err,records)->
    if(records?&&records[0]?)
      diary = records[0]
      diary.pass = null
    else
      diary =
        _id:null
        date:today
        content:''
        pass:null
        passCheck:null

    new WriteVue(
      el:config.domIds.main
      data:diary
    )

  )



