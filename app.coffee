require("bucket-node").initSingletonBucket 'cms.db', (data) ->

  coffeeScript = require("coffee-script")
  express = require("express")
  path = require("path")
  favicon = require("static-favicon")
  logger = require("morgan")
  cookieParser = require("cookie-parser")
  bodyParser = require("body-parser")
  routes = require("./routes/index")
  app = express()

  #console.log process.env.NODE_ENV

  app.set "port", process.env.PORT or 3000
  app.set "view engine", "jade"
  app.use favicon()
  app.use logger("dev")
  app.use bodyParser.json()
  app.use bodyParser.urlencoded()
  app.use cookieParser()
  
  app.use require("coffee-middleware")(src: path.join(__dirname, "public"))
  
  app.use "/css", require("less-middleware")(path.join(__dirname, "public", "less"),
    dest: path.join(__dirname, "public", "css")
    debug: true
    parser:
      paths: [ path.join(__dirname, "public", "bower_components") ]
  )

  if process.env.NODE_ENV == "production"
    app.set "views", path.join(__dirname, "dist/views")
    app.use express.static(path.join(__dirname, "dist"))
  else
    app.set "views", path.join(__dirname, "views")
    app.use express.static(path.join(__dirname, "public"))

  routes.init(app)

  server = app.listen(app.get("port"), ->
    console.log "Express server listening on port " + server.address().port
    return
  )
