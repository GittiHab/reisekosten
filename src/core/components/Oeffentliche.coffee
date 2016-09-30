Reisemittel = require './Reisemittel'
mergeData = require '../mergeObjects'

class Oeffentliche extends Reisemittel

  @roundAccuracy = 100

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

  getTax: =>
    accuracy = Oeffentliche.roundAccuracy
    return (Math.round @amount * Reisemittel.taxHeight/(100 + Reisemittel.taxHeight) * accuracy) / accuracy

module.exports = Oeffentliche