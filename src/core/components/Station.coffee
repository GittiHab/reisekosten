{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Oeffentliche = require './Oeffentliche'
Privat = require './Privat'
Verpflegung = require './Verpflegung'
Reisemittel = require './Reisemittel'

class Station

  constructor: (@reason = '', @text = '', @city = '', @country = 'Deutschland', @inland = true) ->
    @entryDate = null
    @exitDate = null
    @verpflegung = []
    @transportations = []

  setEntryDate: (entryDate) => @entryDate = entryDate

  setExitDate: (exitDate) => @exitDate = exitDate

  getEntryDate: () => @entryDate

  getExitDate: () => @exitDate

  setReason: (reason) => @reason = reason

  setText: (text) => @text = text

  setLocation: (city, country) =>
    @setCity city
    @setCountry country

  setCity: (city) => @city = city
  setcountry: (country) => @country = country

  getLocation: () => @city + ' ' + @country

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
    @setEntryDate new Date Date.parse @entryDate
    @setExitDate new Date Date.parse @exitDate

module.exports = Station