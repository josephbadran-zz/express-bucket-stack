fs    = require 'fs'
async = require 'async'

cont = (failPath, prereq) ->
  (happyPath) ->
    async.apply prereq, failPath, happyPath
    # async.apply(async.apply(prereq, failPath), happyPath)

exports.cont = (failPath) ->
  cont failPath, (failPath, happyPath, err, results...) ->
    if err? and err != false
      failPath(err)
    else
      happyPath(results...)

exports.dont = (failPath) ->
  cont failPath, (failPath, happyPath, err, results...) ->
    if err? and err != false
      happyPath(err)
    else
      failPath(results...)


exports.contin = (fn) -> do (fn) ->
  (args...) ->
    cb =  args.pop()
    cont = exports.cont cb
    ret = async.apply cb, null
    fn cont, ret, args...
    
exports.co = (fn) -> do (fn) ->
  (args...) ->
    cb =  args.pop()
    promis =
      CONT : exports.cont cb
      RET  : async.apply cb, null
      DONT : exports.dont cb
      ERR  : cb
      PASS : cb
      ASSERTNULL: (nullval, msg) -> if not nullval? then cb msg
    fn promis, args...


exports.noNullsContract = (fn) ->
  (args...) ->
    
    fn(args...)
