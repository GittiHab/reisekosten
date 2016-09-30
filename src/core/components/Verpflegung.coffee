mergeData = require '../mergeObjects'

class Verpflegung

  # @param [Integer] dayRate The amount received back per person per day
  # @param [Date] from The beginning of the flat
  # @param [Date] to The end of the flat
  #   from to to shouldn't go across more than 24 hours.
  # @param [Boolean] breakfast If the flat should INCLUDE breakfast (meaning if you had breakfast paid, set to false)
  # @param [Boolean] lunch If the flat should include lunch
  # @param [Boolean] dinner If the flat should include dinner
  # @param [Integer] number For how many people doese this flat count
  constructor: (@dayRate = {halfday: 0, fullday: 0}, @from = 0, @to = 0, @breakfast = true, @lunch = true, @dinner = true, @number = 1) ->
    @rates =
      breakfast: 20
      lunch: 40
      dinner: 40
    @halfDayLimit = 8 # how long should you have stayed at least (in hours)

  getFlat: () =>
    # fullday/halfday?
    key = @_getLengthCategory()
    if key is 'none'
      return 0
    # Given rate
    flat = @number * @dayRate[key]
    # Inclusive flats
    flat *= @_calculateFood()
    return flat

  _calculateFood: =>
    return (@breakfast * @rates.breakfast + @lunch * @rates.lunch + @dinner * @rates.dinner) / 100

  # Find out how long the stay was
  # halfday = 8-24 hours
  # fullday = 24+ hours
  _getTimeLength: (inHours = true) =>
    time = @to.getTime() - @from.getTime()
    if inHours
      time /= 1000 * 60 * 60
    return time

  _getLengthCategory: =>
    time = @_getTimeLength()
    if time < @halfDayLimit
      return 'none'
    else if time < 24
      return 'halfday'
    else
      return 'fullday'

  setTo: (to) => @to = to

  getTo: () => @to

  setFrom: (from) => @from = from

  getFrom: () => @from

  setNumber: (number) => @number = number

  setRate: (rate) => @rate = rate

  setBreakfast: (breakfast) => @breakfast = breakfast

  setLunch: (lunch) => @lunch = lunch

  setDinner: (dinner) => @dinner = dinner

  getAmountBack: (country, placeholders) =>
    if not placeholders
      return @getFlat()
    category = @_getLengthCategory()
    if category is 'none'
      return 0
    type = if category is 'fullday' then 'fd' else 'hd'
    return  @_calculateFood() + '*{{' + country + '.' + type + '}}'

  # Create a new flat from existing data
  @createFromData: (data) ->
    flat = new Verpflegung

    # merge in own data
    mergeData flat, data

    flat.createDates()

    return flat

  createDates: () ->
    @setFrom new Date Date.parse @from
    @setTo new Date Date.parse @to

module.exports = Verpflegung