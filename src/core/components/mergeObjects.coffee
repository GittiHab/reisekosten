mergeData = (object, data) ->
  for attrname in data
    object[attrname] = data[attrname]

module.exports = mergeData