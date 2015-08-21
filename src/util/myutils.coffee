
showInfoNoticeWindow = (noticeMessage,timeout)->
  alert(noticeMessage)

showWarningNoticeWindow = (noticeMessage)->
  alert(noticeMessage)

showErrorNoticeWindow = (noticeMessage)->
  alert(noticeMessage)

showSuccessNoticeWindow = (noticeMessage)->
  alert(noticeMessage)

oceanUtil = {
  showInfoNoticeWindow: showInfoNoticeWindow
  showWarningNoticeWindow:showWarningNoticeWindow
  showErrorNoticeWindow:showErrorNoticeWindow
  showSuccessNoticeWindow:showSuccessNoticeWindow
}

module.exports = oceanUtil