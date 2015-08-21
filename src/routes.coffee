main = require('./route/main')
login = require('./route/login')
signup = require('./route/signup')
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




module.exports = routes