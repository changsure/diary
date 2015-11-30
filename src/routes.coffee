main = require('./route/main')
login = require('./route/login')
signup = require('./route/signup')
reset = require('./route/reset_pass')
forget = require('./route/forget')
write = require('./route/write')
read = require('./route/read')

routes =
  '/main':()->
    main()
  '/login':()->
    login()
  '/signup':()->
    signup()
  '/write':()->
    write()
  '/read':()->
    read()
  '/forget':()->
    forget()
  '/reset/:token':(token)->
    reset(token)




module.exports = routes