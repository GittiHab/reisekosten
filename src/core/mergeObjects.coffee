mergeData = (object, data) ->
  for attrname of data
    object[attrname] = data[attrname]

module.exports = mergeData