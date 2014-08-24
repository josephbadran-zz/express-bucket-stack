require("bucket-node").initSingletonBucket("db/cms.db", (data) ->

  #debug = require('debug')('app');
  coffeeScript = require("coffee-script")
  express = require("express")
  path = require("path")
  favicon = require("static-favicon")
  logger = require("morgan")
  cookieParser = require("cookie-parser")
  session = require("express-session")
  bodyParser = require("body-parser")
  routes = require("./controllers/routes")
  app = express()

  app.set "view engine", "jade"
  app.use favicon()
  app.use logger("dev")
  app.use bodyParser.json()
  app.use bodyParser.urlencoded()
  app.use cookieParser()
  app.use session
    secret: "mv8siIE"
    resave: true
    saveUninitialized: true


  app.use require("coffee-middleware")(src: path.join(__dirname, "public"))
  app.use "/css", require("less-middleware")(path.join(__dirname, "public", "less"),
    dest: path.join(__dirname, "public", "css")
    debug: true
    parser:
      paths: [ path.join(__dirname, "public", "bower_components") ]
  )

  app.use express.static(path.join(__dirname, "public"))

  routes.init(app)


  app.use (req, res, next) ->
    err = new Error("Not Found")
    err.status = 404
    next(err)

  if app.get("env") is "development"
    app.set "views", path.join(__dirname, "views")
    app.use (err, req, res, next) ->
      res.status err.status or 500
      res.render "error",
        message: err.message
        error: err
  else
    app.set "views", path.join(__dirname, "dist/views")
    app.use express.static(path.join(__dirname, "dist"))
    app.use (err, req, res, next) ->
      res.status err.status or 500
      res.render "error",
        message: err.message
        error: {}


  app.set('port', process.env.PORT || 3000)

  server = app.listen(app.get("port"), ->
    console.log("Express server listening on port " + server.address().port)
  )
)
