{addItem, removeItem} = require './arrayManager'

class Reise

  constructor: (@title) ->
    @creationDate = new Date()
    @start = null
    @end = null
    @number = null
    @stations = []
    @bills = []

  setStart: (start) => @start = start

  setEnd: (end) => @end = end

  setNumber: (number) => @number = number

  getStart: () => @start

  getEnd: () => @end

  getTitle: () => @title

  addStation: (station) => addItem @, 'stations', station

  removeStation: (station) =>
    if @stations.length - 1 < 3
      return
    removeItem @, 'stations', station
    return

  addBill: (bill) => addItem @, 'bills', bill

  removeBill: (bill) => removeItem @, 'bills', bill

module.exports = Reise
