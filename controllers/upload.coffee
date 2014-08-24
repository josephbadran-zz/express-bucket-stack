bucket = require("bucket-node").bucket
_ = require("underscore")
fs = require("fs")
formidable = require("formidable")

exports.uploadFile = (req, res) ->
  form = new formidable.IncomingForm()
  files = []

  form.on("file", (field, file) ->
    files.push(file)
  )
  .on("end", () ->
    _.each files, (file) ->
      saveToBucket file, (err,id,thumbnail) ->
        unless err?
          res.json({id: id, thumbnail: thumbnail}) 
        else
          res.end("Upload failed: " + err)
  )

  form.parse(req)


saveToBucket = (file, cb) ->
  name = file.name.replace /\s/g, "_"
  oldPath = file.path
  uploadPath = "./public/upload/#{name}"
  thumbnail = "/upload/#{name}"

  fs.rename oldPath, uploadPath, (err) ->
    if not err
      id = bucket.set {type: "file", url: "/upload/#{name}"}
      bucket.store (err)->
        cb(err,id,thumbnail)
    else
      cb(err)