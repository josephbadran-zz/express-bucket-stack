_      = require "underscore"
bucket = require("bucket-node").bucket

exports.authenticate = (req, res, next) ->
  if req.session.user?
    next()
  else
    res.redirect "/admin/login"

exports.login = (req, res) ->
  res.render "admin/login"

exports.validate = (req, res) ->
  username = req.body.username
  password = req.body.password
  user = bucket.findWhere {type: "adminUser", name: username, password: password}
  if user? && _.contains user.permissions, "ksite"
    req.session.user = user
    res.redirect "/admin"
  else
    res.redirect "/admin/login"

exports.logout = (req, res) ->
  req.session.destroy()
  res.redirect "/admin/login"

