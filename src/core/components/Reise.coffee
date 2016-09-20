{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Station = require './Station'
Beleg = require './Beleg'

class Reise

  constructor: (@title = '', fromScratch = true) ->
    @creationDate = new Date()
    @number = 0
    @oldStart = 0
    @stations = []
    @bills = []
    @id = 0
    if fromScratch
      defaultStations = [
        {city: 'Berlin', note: 'Reisebeginn'},
        {city: '', note: 'Reiseziel'},
        {city: 'Berlin', note: 'Reiseende'}]
      for stationData in defaultStations
        station = new Station
        station.setCity stationData.city
        station.setText stationData.note
        @addStation station


  setNumber: (number) => @number = number

  getNumber: () => @number

  getStart: () =>
    start = null
    for station in @stations
      curDate = station.getEntryDate()
      if curDate < start or not start?
        start = curDate
    @oldStart = start
    return if start? then start else new Date()

  getOldStart: () => @oldStart

  getEnd: () =>
    end = null
    for station in @stations
      curDate = station.getExitDate()
      if curDate < end or not end?
        end = curDate
    return if end? then end else new Date()

  getTitle: () => @title

  setTitle: (title) => @title = title

  getId: () => @id

  generateId: (index) => @id = index + '_' + Math.round Math.random() * 1000

  addStation: (station = null) =>
    if not station?
      station = new Station
    addItem @, 'stations', station

  removeStation: (station) =>
    if @stations.length - 1 < 3
      return
    removeItem @, 'stations', station
    return

  addBill: (bill = null) =>
    if not bill?
      bill = new Beleg
    addItem @, 'bills', bill

  removeBill: (bill) => removeItem @, 'bills', bill

  # Create a new travel from existing data
  @createFromData: (data) ->
    reise = new Reise '', false

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
