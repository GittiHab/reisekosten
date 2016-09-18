Reisemittel = require './Reisemittel'

class Oeffentliche extends Reisemittel

  constructor: (@name, @amount) ->

  setAmount: (amount) => @amount = amount

  isOeffentliche: () -> true

module.exports = Oeffentliche