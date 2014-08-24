_ = require('./kunderscore').init()

# Crudder creates crud resource routing for controller
# Send in an url, array of methods to setup routes for,
# config-object containing model and middlewares and 
# it will set upp app routes. add config.json as true 
# to set up json routes 

crudConfig = 
  defaults: 
    methods: [
      'index' 
      'create'
      'show'
      'new'
      'edit'
      'delete'
      'update'
    ]
    json:false


exports.init = (config) ->
  crudConfig = config

exports.crud = (app, url, config) -> 
  config = _.defaults(config, crudConfig.defaults)
  if not config.json
    _.chain({
      index: (url, middlewares, model)  ->   ['get', url, middlewares..., model.index]
      create: (url, middlewares, model) ->   ['post', url, middlewares..., model.create]
      delete: (url, middlewares, model) ->   ['post', url+'/delete', config.middlewares..., model.delete]
      show: (url, middlewares, model)   ->   ['get', url+'/:id', config.middlewares..., model.show]
      new: (url, middlewares, model)    ->   ['get', url+'/new/edit', config.middlewares..., model.new]
      edit: (url, middlewares, model)   ->   ['get', url+'/:id/edit', config.middlewares..., model.edit]
      update: (url, middlewares, model) ->   ['post', url+'/:id', config.middlewares..., model.update]

      })
      .case(config.methods, url, config.middlewares, config.model)
      .map((def) -> app[def[0]](def.slice(1)...))

  else
    app.get url+'/json', config.middlewares..., config.model.indexJson
    app.get url+'/:id'+'/json', config.middlewares..., config.model.showJson



