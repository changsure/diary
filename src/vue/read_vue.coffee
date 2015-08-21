Vue = require('vue')
dateFormat = require('dateformat')
_ = require('underscore')

exchangeService = require('./../service/exchange_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')
config = require('./../config')



WriteVue = Vue.extend({
  template: require('../template/read.html')
  ready:()->
    this.initDiary()
    this.queryArroundMonthDiary(new Date(),()=>
      this.bindDatePicker()
    )


  methods:
    openLockedDiary: ()->
      if(this.$data.passCheck != encryptUtil.sha1Hash(this.$data.pass))
        alert('Not Right')
      else
        this.$data.content = encryptUtil.aesDecrypt(this.$data.content, this.$data.pass)
        $('#lock_modal').modal('hide')

        $("#diary_content").removeClass('hidden')
        $("#diary_content_locked").addClass('hidden')

        $("#do_open_locked_diary").addClass('hidden')
        $("#icon_openlock").addClass('hidden')
        $("#icon_locked").removeClass('hidden')

    bindDatePicker:()->
      $('.fa-calendar').datepicker(
        autoclose: true,
        beforeShowDay:(date)=>
          onlyDate = dateFormat(date, 'yyyy-mm-dd')
          if(date > new Date())
            return false
          if(_.contains(window.allowDates,onlyDate))
            return true
          else
            return false

      ).on('hide',(e)=>
        this.selectDateDiary(e.date)
      ).on('changeMonth',(e)=>
        # fetch arround records
        this.queryArroundMonthDiary(e.date)
      )

    initDiary:()->
      $("#modal_pass_input").keydown((e)=>
        key = e.which
        if(key == 13)
          this.openLockedDiary()
      )

      $('#lock_modal').on('shown.bs.modal', ()->
        $('#modal_pass_input').focus()
      )

      if(this.$data.passCheck? && this.$data.passCheck != '')
        $("#diary_content").addClass('hidden')
        $("#diary_content_locked").removeClass('hidden')
        $("#icon_openlock").removeClass('hidden')
        $("#icon_locked").removeClass('hidden')

        $('#lock_modal').modal('show')

      else
        $("#diary_content").removeClass('hidden')
        $("#diary_content_locked").addClass('hidden')
        $("#icon_openlock").addClass('hidden')
        $("#icon_locked").addClass('hidden')

    selectDateDiary:(date)->
      criteria =
        date:dateFormat(date, 'yyyy-mm-dd')
      exchangeService.queryDiary(criteria,null,null,(e,records)=>
        if(records?&&records[0]?)
          this.$data = records[0]
          this.initDiary()
        else if(e?)
          alert(e.errorMessage)
      )

    queryArroundMonthDiary:(date,callback)->
      fromDate = new Date(date.getTime() - (90 * 24 * 60 * 60 * 1000))
      endDate = new Date(date.getTime() + (90 * 24 * 60 * 60 * 1000))

      criteria =
        createTime:
          $lt:endDate.getTime()
          $gt:fromDate.getTime()
      exchangeService.queryDiary(criteria,'date',null,(e,records)=>
        if(records?)
          window.allowDates = _.map(records,(record)->
            return record.date
          )

        if(callback?)
          callback()
      )

})

module.exports = WriteVue