Reisemittel = require './Reisemittel'
mergeData = require '../mergeObjects'

class Privat extends Reisemittel

  # @param [Integer] distance The distance travelled with this transportation type in km
  # @param [Boolean] business Has the transportation been provided by the company
  # @param [Boolean] motorcycle If the transportation type was a car of motorcycle
  constructor: (@name = '', @distance = 0, @business = false, @rate = 0, @motorcycle = false) ->

  setDistance: (distance) => @distance = distance

  setBusiness: (business) => @business = business

  setRate: (rate) => @rate = rate

  setMotorcycle: (motorcycle) => @motorcycle = motorcycle

  isPrivat: () -> true

  getFlat: () ->
    if @business
      return 0
    type = if @motorcycle then 'motorcycle' else 'pkw'
    return @distance * @rate[type]

  # Create a new private transport from existing data
  @createFromData: (data) ->
    transport = new Privat

    # merge in own data
    mergeData transport, data

    return transport

  getAmountBack: (country, placeholders) =>
    #      TODO: Use saved flats
    #      if includeRates
    #        tmp_total *= flat
    type = if @motorcycle then 'mc' else 'pkw'
    if @business then type += '.business'
    return @distance + '*{{' + type + '.km}}'

  getTax: -> 0

module.exports = Privat