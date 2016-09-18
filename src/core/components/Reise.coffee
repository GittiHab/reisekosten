{addItem, removeItem} = require './arrayManager'
mergeData = require './mergeObjects'
Station = require './Station'
Beleg = require './Beleg'

class Reise

  constructor: (@title = '') ->
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

  addBill: (bill = null) =>
    if not bill?
      bill = new Beleg 0, 0, '', 0
    addItem @, 'bills', bill

  removeBill: (bill) => removeItem @, 'bills', bill

  # Create a new travel from existing data
  @createFromData: (data) ->
    reise = new Reise

    # Add associated objects
    for station in data.stations
      station = Station.createFromData station
      reise.addStation station
    delete data.stations
    for bill in data.bills
      bill = Beleg.createFromData bill
      reise.addBill bill
    delete data.bills

    # merge in own data
    mergeData reise, data

    return reise

module.exports = Reise
