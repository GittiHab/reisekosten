mergeData = require '../mergeObjects'

class Beleg

  @roundingAccuracy = 100

  # Create a new Beleg (Bill)
  # @param [Date] date The date on the bill
  # @param [Integer] tax
  #   A number between 0 - 100 which is the tax paid with this bill
  #   This can be set to null if it is an non-inland bill
  # @param [String] text A short note about what this is about
  # @param [Float] amount The amount of the bill as stated on it in the original currency
  # @param [String] currency The currency the bill is in (please use the 3 Letter shortcode)
  # @param [Float] amountEur The amount of the bill converted in Euro – best if provided by the bank
  constructor: (@date = 0, @tax = 0, @text = '', @amount = 0, @currency = 'EUR', @amountEur = 0) ->


  setDate: (date) => @date = date
  setTax: (tax) => @tax = tax
  setText: (text) => @text = text
  setAmount: (amount) => @amount = amount
  setCurrency: (currency) => @currency = currency
  setEuros: (amountEur) => @amountEur = amountEur

  # @returns [Float] Returns the amount of you receive back for this bill.
  #   For German bills this is the amount of tax paid
  #   For other bills it is the total amount in Euros (if tax is 0)
  getAmountBack: =>
    amount = if @currency isnt 'EUR' then @amountEur else @amount
    return amount

  getTax: => @tax

  getTaxAmount: =>
    if @tax is 0
      return 0
    accuracy = Beleg.roundingAccuracy
    # calculate tax
    return (Math.round @tax/(100 + @tax) * @getAmountBack() * accuracy) / accuracy


  # Create a new bill from existing data
  @createFromData: (data) ->
    bill = new Beleg

    # update old files
    if data.amounEur?
      data.amountEur = data.amounEur
      delete data.amounEur

    # merge in own data
    mergeData bill, data

    bill.createDates()

    return bill

  createDates: () ->
    @setDate new Date Date.parse @date

module.exports = Beleg