{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Station = require './Station'
Beleg = require './Beleg'
Reisemittel = require './Reisemittel'

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

  getCountries: => (station.getCountry() for station in @stations)

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

  # @returns [String] The list of all stations as a string
  serializeStations: =>
    string = ''
    for station, i in @stations
      string += station.getCountry()
      if i isnt @stations.length - 1
        string += '; '
    return string

  # @see Station.calculateTransport
  calculateTransport: (includeRates = true) =>
    total = 0
    for station in @stations
      total += station.calculateFlats includeRates
    return

  # @see Station.calculateFlats
  calculateFlats: (includeFlats = true) =>
    total = 0
    for station in @stations
      total += station.calculateFlats includeFlats
    return

  # Calculates the total amount you would receive back from the tax for the bills
  calculateBills: =>
    total = 0
    for bill in @bills
      total += bill.getAmountBack()
    return total

  # Calculates all total tax amounts for the different tax heights
  calculateTaxes: =>
    taxes = {}
    @_transportTax taxes
    @_billsTax taxes
    return taxes

  # Calculate the tax total for the transportation and save it into taxObj
  _transportTax: (taxObj) =>
    taxObj[Reisemittel.taxHeight] = 0
    for station in @stations
      taxObj[Reisemittel.taxHeight] = station.getTransportTax()

  # Calculate the different tax totals for all bills and save it into taxObj
  _billsTax: (taxObj) =>
    for bill in @bills
      tax = bill.getTax()
      if tax is 0
        continue
      if taxObj[tax]?
        taxObj[tax] += bill.getTaxAmount()
      else
        taxObj[tax] = bill.getTaxAmount()

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
