class Private extends Reisemittel

  # @param [Integer] distance The distance travelled with this transportation type in km
  # @param [Boolean] business Has the transportation been provided by the company
  # @param [Boolean] motorcycle If the transportation type was a car of motorcycle
  constructor: (@name, @distance, @business, @rate, @motorcycle = false) ->

  getFlat: () ->
    if @business
      return 0
    type = if @motorcycle then 'motorcycle' else 'pkw'
    return @distance * @rate[type]

  getName: () -> @name