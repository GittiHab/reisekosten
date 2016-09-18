class Beleg

  # Create a new Beleg (Bill)
  # @param [Date] date The date on the bill
  # @param [Integer] tax
  #   A number between 0 - 100 which is the tax paid with this bill
  #   This can be set to null if it is an non-inland bill
  # @param [String] text A short note about what this is about
  # @param [Float] amount The amount of the bill as stated on it in the original currency
  # @param [String] currency The currency the bill is in (please use the 3 Letter shortcode)
  # @param [Float] amountEur The amount of the bill converted in Euro – best if provided by the bank
  constructor: (@date, @tax, @text, @amount, @currency = 'EUR', @amountEur = null) ->


  setDate: (date) => @date = date
  setTax: (tax) => @tax = tax
  setText: (text) => @text = text
  setAmount: (amount) => @amount = amount
  setCurrency: (currency) => @currency = currency
  setEuros: (amountEur) => @amountEur = amountEur

module.exports = Beleg