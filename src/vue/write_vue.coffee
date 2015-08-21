Vue = require('vue')
_ = require('underscore')
exchangeService = require('./../service/exchange_service')
myutils = require('./../util/myutils')
encryptUtil = require('./../util/encrypt_util')
config = require('./../config')
dateFormat = require('dateformat')

WriteVue = Vue.extend(
  template: require('../template/write.html')
  ready: ()->

    $("#diary_content textarea").focus()

    $('#lock_modal').on('shown.bs.modal', ()->
      $('#modal_pass_input').focus()
    )

    # bind enter to pass
    $("#modal_pass_input").keydown((e)=>
      if(e.which == 13 || e.keyCode == 13)
        if($("#do_open_locked_diary:visible").size()>0)
          this.openLockedDiary()
    )

    # bind ctrl command s to save
    $("#diary_content").keydown((e)=>

      if((e.ctrlKey || e.metaKey) && (e.which == 83 || e.keyCode == 83))
        this.save()
        e.preventDefault();
        return false;
    )

    # init icon show or hidden
    if(this.$data.passCheck? && this.$data.passCheck != '')

      $("#diary_content").addClass('hidden')
      $("#diary_content_locked").removeClass('hidden')

      $("#icon_locked").addClass('hidden')
      $("#icon_openlock").removeClass('hidden')
      $("#icon_unlocked").addClass('hidden')

      $("#icon_do_save").addClass('hidden')
      $("#icon_do_save_disable").removeClass('hidden')
      $("#do_lock_diary").addClass('hidden')
      $("#do_open_locked_diary").removeClass('hidden')

    else
      this.$data.content = _.unescape(this.$data.content)
      $("#diary_content").removeClass('hidden')
      $("#diary_content_locked").addClass('hidden')

      $("#icon_locked").addClass('hidden')
      $("#icon_openlock").addClass('hidden')
      $("#icon_unlocked").removeClass('hidden')

      $("#icon_do_save").removeClass('hidden')
      $("#icon_do_save_disable").addClass('hidden')
      $("#do_lock_diary").removeClass('hidden')
      $("#do_open_locked_diary").addClass('hidden')

    # auto save in 1 minutes
    window.setInterval(this.save, 60 * 1000);

    #show input lock key
    if(this.$data.passCheck? && this.$data.passCheck != '')
      $('#lock_modal').modal('show')

  methods:
    save: ()->

      if(!this.$data.content? || this.$data.content == '' || this.$data.content == this.$data.savedContent)
        return
      if((!this.$data.pass? || this.$data.pass=='') && (this.$data.passCheck? && this.$data.passCheck!=''))
        return

      if(this.$data.passCheck? && this.$data.passCheck != '')
        diary =
          date: this.$data.date
          content: encryptUtil.diaryEncrypt(_.escape(this.$data.content), this.$data.pass)
          passCheck: this.$data.passCheck
      else
        diary =
          date: this.$data.date
          content: _.escape(this.$data.content)
          passCheck: null

      if(this.$data._id?)
        diary._id = this.$data._id

      $("#icon_saving").removeClass('hidden')
      exchangeService.saveDiary(diary._id, diary, (err, record)=>
        $("#icon_saving").addClass('hidden')
        if(err?)
          alert(err.errorMessage)
        else
          this.$data._id = record._id
          this.$data.savedContent = this.$data.content
          this.$data.$set('updateTime',record.updateTime)
      )

    lockDiary: ()->
      if(!this.$data.pass? || this.$data.pass == '')
        return

      this.$data.passCheck = encryptUtil.sha1Hash(this.$data.pass)
      $('#lock_modal').modal('hide')

      $("#do_lock_diary").addClass('hidden')
      $("#do_open_locked_diary").addClass('hidden')
      $("#icon_openlock").addClass('hidden')
      $("#icon_locked").removeClass('hidden')
      $("#icon_unlocked").addClass('hidden')
      $("#diary_content textarea").focus()
      this.save()

    openLockedDiary: ()->
      if(this.$data.passCheck != encryptUtil.sha1Hash(this.$data.pass))
        alert('Not Right')
      else
        this.$data.content = _.unescape(encryptUtil.diaryDecrypt(this.$data.content, this.$data.pass))
        $('#lock_modal').modal('hide')

        $("#diary_content").removeClass('hidden')
        $("#diary_content_locked").addClass('hidden')

        $("#do_lock_diary").addClass('hidden')
        $("#do_open_locked_diary").addClass('hidden')
        $("#icon_do_save").removeClass('hidden')
        $("#icon_do_save_disable").addClass('hidden')
        $("#icon_openlock").addClass('hidden')
        $("#icon_locked").removeClass('hidden')
        $("#icon_unlocked").addClass('hidden')

        $("#diary_content textarea").focus()

)

module.exports = WriteVue