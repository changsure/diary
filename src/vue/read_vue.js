// Generated by CoffeeScript 1.9.2
var Vue, WriteVue, _, config, dateFormat, encryptUtil, exchangeService, myutils;

Vue = require('vue');

dateFormat = require('dateformat');

_ = require('underscore');

exchangeService = require('./../service/exchange_service');

myutils = require('./../util/myutils');

encryptUtil = require('./../util/encrypt_util');

config = require('./../config');

WriteVue = Vue.extend({
  template: require('../template/read.html'),
  ready: function() {
    this.bindInit();
    this.initDiary();
    $("#icon_next").addClass("hidden");
    return this.queryArroundMonthDiary(new Date(), (function(_this) {
      return function() {
        return _this.bindDatePicker();
      };
    })(this));
  },
  methods: {
    bindInit: function() {
      $("#modal_pass_input").keydown((function(_this) {
        return function(e) {
          var key;
          key = e.which;
          if (key === 13) {
            return _this.openLockedDiary();
          }
        };
      })(this));
      return $('#lock_modal').on('shown.bs.modal', function() {
        return $('#modal_pass_input').focus();
      });
    },
    initDiary: function() {
      var ref;
      if ((this.$data.passCheck != null) && this.$data.passCheck !== '') {
        $("#diary_content").addClass('hidden');
        $("#diary_content_locked").removeClass('hidden');
        $("#icon_openlock").removeClass('hidden');
        $("#icon_locked").removeClass('hidden');
        $('#lock_modal').modal('show');
      } else {
        $("#diary_content").removeClass('hidden');
        $("#diary_content_locked").addClass('hidden');
        $("#icon_openlock").addClass('hidden');
        $("#icon_locked").addClass('hidden');
        $("#diary_content_html").html((ref = this.$data.content) != null ? ref.replace(/\n/g, '<br>') : void 0);
      }
      $("#icon_pre").removeClass("hidden");
      $("#icon_next").removeClass("hidden");
      if (this.$data.date === window.earliestDiaryDate) {
        $("#icon_pre").addClass("hidden");
      }
      if (this.$data.date === window.recentDiaryDate) {
        return $("#icon_next").addClass("hidden");
      }
    },
    bindDatePicker: function() {
      return $('.fa-calendar').datepicker({
        autoclose: true,
        beforeShowDay: (function(_this) {
          return function(date) {
            var onlyDate;
            onlyDate = dateFormat(date, 'yyyy-mm-dd');
            if (date > new Date()) {
              return false;
            }
            if (_.contains(window.allowDates, onlyDate)) {
              return true;
            } else {
              return false;
            }
          };
        })(this)
      }).on('hide', (function(_this) {
        return function(e) {
          return _this.selectDateDiary(e.date);
        };
      })(this)).on('changeMonth', (function(_this) {
        return function(e) {
          return _this.queryArroundMonthDiary(e.date);
        };
      })(this));
    },
    openLockedDiary: function() {
      var ref;
      if (this.$data.passCheck !== encryptUtil.sha1Hash(this.$data.pass)) {
        return alert('Not Right');
      } else {
        $('#lock_modal').modal('hide');
        $("#diary_content").removeClass('hidden');
        $("#diary_content_locked").addClass('hidden');
        $("#do_open_locked_diary").addClass('hidden');
        $("#icon_openlock").addClass('hidden');
        $("#icon_locked").removeClass('hidden');
        this.$data.content = encryptUtil.diaryDecrypt(this.$data.content, this.$data.pass);
        return $("#diary_content_html").html((ref = this.$data.content) != null ? ref.replace(/\n/g, '<br>') : void 0);
      }
    },
    selectDateDiary: function(date) {
      var criteria;
      criteria = {
        date: dateFormat(date, 'yyyy-mm-dd')
      };
      return exchangeService.queryDiary(criteria, null, null, (function(_this) {
        return function(e, records) {
          if ((records != null) && (records[0] != null)) {
            _this.$data = records[0];
            return _this.initDiary();
          } else if ((e != null)) {
            return alert(e.errorMessage);
          }
        };
      })(this));
    },
    queryArroundMonthDiary: function(date, callback) {
      var criteria, endDate, fromDate;
      fromDate = new Date(date.getTime() - (90 * 24 * 60 * 60 * 1000));
      endDate = new Date(date.getTime() + (90 * 24 * 60 * 60 * 1000));
      criteria = {
        createTime: {
          $lt: endDate.getTime(),
          $gt: fromDate.getTime()
        }
      };
      return exchangeService.queryDiary(criteria, 'date', null, (function(_this) {
        return function(e, records) {
          if ((records != null)) {
            window.allowDates = _.map(records, function(record) {
              return record.date;
            });
          }
          if ((callback != null)) {
            return callback();
          }
        };
      })(this));
    },
    preDiary: function() {
      var criteria, rowDes;
      criteria = {
        createTime: {
          $lt: this.$data.createTime
        }
      };
      rowDes = {
        limit: 1,
        sort: {
          createTime: -1
        }
      };
      return exchangeService.queryDiary(criteria, null, rowDes, (function(_this) {
        return function(err, records) {
          if ((typeof e !== "undefined" && e !== null)) {
            return alert(e.errorMessage);
          } else if ((records != null) && (records[0] != null)) {
            _this.$data = records[0];
            return _this.initDiary();
          } else if ((records != null ? records.length : void 0) === 0) {
            return $("#icon_pre").addClass("hidden");
          }
        };
      })(this));
    },
    nextDiary: function() {
      var criteria, rowDes;
      criteria = {
        createTime: {
          $gt: this.$data.createTime
        }
      };
      rowDes = {
        limit: 1,
        sort: {
          createTime: 1
        }
      };
      return exchangeService.queryDiary(criteria, null, rowDes, (function(_this) {
        return function(err, records) {
          if ((typeof e !== "undefined" && e !== null)) {
            return alert(e.errorMessage);
          } else if ((records != null) && (records[0] != null)) {
            _this.$data = records[0];
            return _this.initDiary();
          } else if ((records != null ? records.length : void 0) === 0) {
            return $("#icon_next").addClass("hidden");
          }
        };
      })(this));
    }
  }
});

module.exports = WriteVue;
