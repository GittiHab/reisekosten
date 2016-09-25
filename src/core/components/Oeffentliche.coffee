Reisemittel = require './Reisemittel'
mergeData = require '../mergeObjects'

class Oeffentliche extends Reisemittel

  constructor: (@name = '', @amount = 0) ->

  setAmount: (amount) => @amount = amount

  isOeffentliche: () -> true

  # Create a new public transport from existing data
  @createFromData: (data) ->
    transport = new Oeffentliche

    # merge in own data
    mergeData transport, data

    return transport

  getAmountBack: => @amount

  getTax: => @amount * 100/(100 + Reisemittel.taxHeight)

module.exports = Oeffentliche