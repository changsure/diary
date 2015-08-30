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
    this.bindInit()
    this.initDiary()
    $("#icon_next").addClass("hidden")

    this.queryArroundMonthDiary(new Date(),()=>
      this.bindDatePicker()
    )

  methods:
    bindInit:()->
      $("#modal_pass_input").keydown((e)=>
        key = e.which
        if(key == 13)
          this.openLockedDiary()
      )

      $('#lock_modal').on('shown.bs.modal', ()->
        $('#modal_pass_input').focus()
      )

    initDiary:()->
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

        $("#diary_content_html").html(this.$data.content?.replace(/\n/g,'<br>'))


      $("#icon_pre").removeClass("hidden")
      $("#icon_next").removeClass("hidden")
      if(this.$data.date == window.earliestDiaryDate)
        $("#icon_pre").addClass("hidden")
      if(this.$data.date == window.recentDiaryDate)
        $("#icon_next").addClass("hidden")

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

    openLockedDiary: ()->
      if(this.$data.passCheck != encryptUtil.sha1Hash(this.$data.pass))
        alert('Not Right')
      else
        $('#lock_modal').modal('hide')
        $("#diary_content").removeClass('hidden')
        $("#diary_content_locked").addClass('hidden')
        $("#do_open_locked_diary").addClass('hidden')
        $("#icon_openlock").addClass('hidden')
        $("#icon_locked").removeClass('hidden')

        this.$data.content = encryptUtil.diaryDecrypt(this.$data.content, this.$data.pass)
        $("#diary_content_html").html(this.$data.content?.replace(/\n/g,'<br>'))

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

    preDiary:()->

      criteria =
        createTime:
          $lt:this.$data.createTime
      rowDes =
        limit: 1
        sort:
          createTime:-1

      exchangeService.queryDiary(criteria,null,rowDes,(err,records)=>
        if(e?)
          alert(e.errorMessage)
        else if(records?&&records[0]?)
          this.$data = records[0]
          this.initDiary()
        else if(records?.length==0)
          $("#icon_pre").addClass("hidden")
      )

    nextDiary:()->
      criteria =
        createTime:
          $gt:this.$data.createTime
      rowDes =
        limit: 1
        sort:
          createTime:1

      exchangeService.queryDiary(criteria,null,rowDes,(err,records)=>
        if(e?)
          alert(e.errorMessage)
        else if(records?&&records[0]?)
          this.$data = records[0]
          this.initDiary()
        else if(records?.length==0)
          $("#icon_next").addClass("hidden")
      )


})

module.exports = WriteVue