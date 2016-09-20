{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Oeffentliche = require './Oeffentliche'
Privat = require './Privat'
Verpflegung = require './Verpflegung'
Reisemittel = require './Reisemittel'
getDates = require '../getDates'

class Station

  constructor: (@reason = '', @text = '', @city = '', @country = 'Deutschland', @inland = true) ->
    defaultDate = new Date()
    defaultDate.setHours 0
    defaultDate.setMinutes 0
    defaultDate.setSeconds 0
    defaultDate.setMilliseconds 0
    @_entryDate = defaultDate
    @exitDate = null
    @verpflegung = []
    @transportations = []

  setEntryDate: (entryDate) => @_entryDate = entryDate

  generateVerpflegung: () ->
    if not @_entryDate? or not @exitDate?
      return
    days = getDates @_entryDate, @exitDate
    for day in days
      if not @_containsDate day
        flat = new Verpflegung
        flat.setFrom day
        @verpflegung.push flat

  _containsDate: (date) ->
    for flat in @verpflegung
      if flat.getFrom().getTime() is date.getTime()
        return true
    return false

  setExitDate: (exitDate) => @exitDate = exitDate

  getEntryDate: () => @_entryDate

  entryDate: (date = null) =>
    if date?
      @_entryDate = date
      if not @exitDate?
        @exitDate = new Date (@_entryDate.getTime() + 1000*3600*24)
    else
      return @_entryDate

  getExitDate: () => @exitDate

  setReason: (reason) => @reason = reason

  setText: (text) => @text = text
  getText: () => @text

  setLocation: (city, country) =>
    @setCity city
    @setCountry country

  setCity: (city) => @city = city
  setcountry: (country) => @country = country

  getLocation: () => @city + ', ' + @country

  getDropdownName: () => @getText() + ': ' + @getLocation()

  setInland: (inland) => @inland = inland

  addVerpflegung: (verpflegung = null) =>
    if not verpflegung?
      verpflegung = new Verpflegung
    addItem @, 'verpflegung', verpflegung

  removeVerpflegung: (verpflegung) => removeItem @, 'verpflegung', verpflegung

  addTransport: (transport = null, publicTransport = false) =>
    if not transport?
      transport = if publicTransport then new Oeffentliche else new Privat
    addItem @, 'transportations', transport

  removeTransport: (transport) => removeItem @, 'transportations', transport

  # Create a new station from existing data
  @createFromData: (data) ->
    station = new Station

    # Add associated objects
    for transport in data.transportations
      # determine type
      transport = if transport.rate? then Privat.createFromData transport else Oeffentliche.createFromData transport
      station.addTransport transport
    delete data.transportations
    for flat in data.verpflegung
      flat = Verpflegung.createFromData flat
      station.addVerpflegung flat
    delete data.verpflegung

    # merge in own data
    mergeData station, data

    station.createDates()

    return station

  createDates: () ->
    @setEntryDate new Date Date.parse @_entryDate
    @setExitDate new Date Date.parse @exitDate

module.exports = Station