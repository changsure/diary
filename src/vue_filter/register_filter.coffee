Vue = require('vue')
dateFormat = require('dateformat')


registerFilter = ()->
  # datetime filter
  Vue.filter('datetime',dateTimeFilter)

dateTimeFilter = (value, pattern)->
  if(!value? || value == 0 || value =='')
    return ''
  datetime = new Date(value)
  if(pattern?)
    formatted = dateFormat(datetime, pattern)
  else
    formatted = dateFormat(datetime, 'mm/dd/yyyy HH:MM:ss')
  return formatted


OceanFilter =
  registerFilter: registerFilter

module.exports = OceanFilter