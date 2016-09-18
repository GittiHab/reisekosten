mergeData = require './mergeObjects'

class Verpflegung

  # @param [Integer] dayRate The amount received back per person per day
  # @param [Date] from The beginning of the flat
  # @param [Date] to The end of the flat
  #   from to to shouldn't go across more than 24 hours.
  # @param [Boolean] breakfast If the flat should INCLUDE breakfast (meaning if you had breakfast paid, set to false)
  # @param [Boolean] lunch If the flat should include lunch
  # @param [Boolean] dinner If the flat should include dinner
  # @param [Integer] number For how many people doese this flat count
  constructor: (@dayRate = 0, @from = 0, @to = 0, @breakfast = false, @lunch = false, @dinner = false, @number = 1) ->
    @rates =
      breakfast: 20
      lunch: 40
      dinner: 40
    @halfDayLimit = 8 # how long should you have stayed at least

  getFlat: () =>
    # fullday/halfday?
    time = @_getTimeLength()
    if time < @halfDayLimit
      return 0
    key = if time < 24 then 'halfday' else 'fullday'
    # Given rate
    flat = @number * @dayRate[key]
    # Inclusive flats
    flat *= (@breakfast * @rates.breakfast + @lunch * @rates.lunch + @dinner * @rates.dinner)/100

  # Find out how long the stay was
  # halfday = 8-24 hours
  # fullday = 24+ hours
  _getTimeLength: (inHours = true) =>
    time = @to.getTime() - @from.getTime()
    if inHours
      time /= 1000 * 60 * 60
    return time

  setTo: (to) => @to = to

  setFrom: (from) => @from = from

  setNumber: (number) => @number = number

  setRate: (rate) => @rate = rate

  setBreakfast: (breakfast) => @breakfast = breakfast

  setLunch: (lunch) => @lunch = lunch

  setDinner: (dinner) => @dinner = dinner

  # Create a new flat from existing data
  @createFromData: (data) ->
    flat = new Verpflegung

    # merge in own data
    mergeData flat, data

    return flat

module.exports = Verpflegung