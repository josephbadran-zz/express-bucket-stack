common = require "./lib/common"

require("bucket-node").initSingletonBucket 'cms.db', (data) ->
  cont = common.cont (err) ->
    console.log "Error!"
    console.dir err
  setupUser data, cont (err) =>
    data.close () ->
      console.log "Success"

setupUser = (data, cb) ->
  data.set {type: "adminUser", name: "admin", password: "admin", permissions: ["ksite"]}
  
  data.store (err) ->
    cb(err)

