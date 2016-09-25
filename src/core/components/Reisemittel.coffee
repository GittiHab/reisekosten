class Reisemittel

  @taxHeight = 19

  constructor: (@name) ->

  setName: (name) => @name = name

  getName: () -> @name

  isOeffentliche: () -> false

  isPrivat: () -> false

  # Abstract method. Calculate the amount you should receive back from the tax
  getAmountBack: (placeholders) => throw new Error 'Method "getAmountBack" needs to be overriden'

  # Abstract method. Return the tax paid for this travel
  getTax: -> throw new Error 'Method "getTax" should be overriden'

module.exports = Reisemittel