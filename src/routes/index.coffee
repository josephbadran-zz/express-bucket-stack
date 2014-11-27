

exports.index = (req, res) ->
  res.render("index")

exports.partials = (req, res) ->
  res.render("partials/" + req.params.name)

