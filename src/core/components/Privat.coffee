Reisemittel = require './Reisemittel'
mergeData = require '../mergeObjects'

class Privat extends Reisemittel

  # @param [Integer] distance The distance travelled with this transportation type in km
  # @param [Boolean] business Has the transportation been provided by the company
  # @param [Boolean] motorcycle If the transportation type was a car of motorcycle
  constructor: (@name, @distance, @business, @rate, @motorcycle = false) ->

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

module.exports = Privat