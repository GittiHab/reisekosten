class Reisemittel

  constructor: (@name) ->

  setName: (name) => @name = name

  getName: () -> @name

  isOeffentliche: () -> false

  isPrivat: () -> false

module.exports = Reisemittel