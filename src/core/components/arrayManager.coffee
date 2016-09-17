addItem = (object, array, item) -> object[array].push item

removeItem = (object, array, item) ->
  index = object[array].indexOf item
  object[array].slice index, 1
  return

module.exports = {addItem, removeItem}