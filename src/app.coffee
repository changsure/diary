director = require('director')
$ = window.$
config = require('./config')
RegisterFilter = require('./vue_filter/register_filter')
pageService = require('./service/page_service')
routes = require('./routes')

$(document).ready(()->
  # Enable cross domain visit.
  $.ajaxPrefilter((options, originalOptions, jqXHR)->
    options.crossDomain = {
      crossDomain: true
    }
  )

  # Register vue filter
  RegisterFilter.registerFilter()
  router = director.Router(routes)

  router.configure(
    notfound: ()->
      window.location = config.siteAddress
  )

  pageService.checkAndRefreshLocalStorage(()->
    router.init('/main')
  )

)







