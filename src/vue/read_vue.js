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
    this.initDiary();
    return this.queryArroundMonthDiary(new Date(), (function(_this) {
      return function() {
        return _this.bindDatePicker();
      };
    })(this));
  },
  methods: {
    openLockedDiary: function() {
      if (this.$data.passCheck !== encryptUtil.sha1Hash(this.$data.pass)) {
        return alert('Not Right');
      } else {
        this.$data.content = encryptUtil.aesDecrypt(this.$data.content, this.$data.pass);
        $('#lock_modal').modal('hide');
        $("#diary_content").removeClass('hidden');
        $("#diary_content_locked").addClass('hidden');
        $("#do_open_locked_diary").addClass('hidden');
        $("#icon_openlock").addClass('hidden');
        return $("#icon_locked").removeClass('hidden');
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
    initDiary: function() {
      $("#modal_pass_input").keydown((function(_this) {
        return function(e) {
          var key;
          key = e.which;
          if (key === 13) {
            return _this.openLockedDiary();
          }
        };
      })(this));
      $('#lock_modal').on('shown.bs.modal', function() {
        return $('#modal_pass_input').focus();
      });
      if ((this.$data.passCheck != null) && this.$data.passCheck !== '') {
        $("#diary_content").addClass('hidden');
        $("#diary_content_locked").removeClass('hidden');
        $("#icon_openlock").removeClass('hidden');
        $("#icon_locked").removeClass('hidden');
        return $('#lock_modal').modal('show');
      } else {
        $("#diary_content").removeClass('hidden');
        $("#diary_content_locked").addClass('hidden');
        $("#icon_openlock").addClass('hidden');
        return $("#icon_locked").addClass('hidden');
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
    }
  }
});

module.exports = WriteVue;