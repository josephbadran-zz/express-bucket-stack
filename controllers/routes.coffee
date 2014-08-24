index = require("./index")
login = require("./login")
admin = require("./admin")
upload = require("./upload")

exports.init = (app) ->
  app.get "/", index.index

  app.get "/admin", login.authenticate, admin.index
  app.get "/admin/login", login.login
  app.post "/admin/login", login.validate
