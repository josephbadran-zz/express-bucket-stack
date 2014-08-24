_ = require 'underscore'

# Library to add usable functions to underscor

# _.case :  Takes one object with methods and one array
#           of chosen methods to run and executes with

exports.init = () ->
  _.mixin({
  case: (methods, chosen, args...) ->
    _(chosen).map((method) ->
      methods[method](args...)
    )
  })
  _.mixin({
    containsKeys : (obj, keyArr) ->
      if not obj.error?
        if _.chain(obj).keys().intersection(keyArr).value().length != keyArr.length
          {}
        else
          obj
      else
        obj
  })
  _.mixin({
    assertUnique : (obj, uniqueKeys, objArr) ->
      objArr = _.filter(objArr, (o) ->
        o.id != obj.id
      )
      if not obj.error?
        if _(_(uniqueKeys).map (key) ->
          if obj[key]?
            if !_.contains(_.pluck(_.flatten([objArr]), key), obj[key])
              key
        ).compact().length == uniqueKeys.length
          obj
        else
          {}
      else
        obj
  })
  _.mixin({
    compactObject: (o) ->
      clone = _.clone(o)
      _.each clone, (v, k) ->
        delete clone[k]  unless v
      clone
  })
  _.mixin({
    ifEmpty: (o, f) ->
      if _.isEmpty(o) && not o.error?
        o.error = 'true'
        f()
      o
  })
  _.mixin({
    lift: (o, f) ->
      if not _.isEmpty(o) && not o.error?
        f(o)
  })

  return _