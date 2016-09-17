{addItem, removeItem} = require './arrayManager'
Station = require './Station'

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

  setTitle: (title) => @title = title

  addStation: (station = null) =>
    if not station?
      station = new Station '', '', ''
    addItem @, 'stations', station

  removeStation: (station) =>
    if @stations.length - 1 < 3
      return
    removeItem @, 'stations', station
    return

  addBill: (bill) => addItem @, 'bills', bill

  removeBill: (bill) => removeItem @, 'bills', bill

module.exports = Reise
