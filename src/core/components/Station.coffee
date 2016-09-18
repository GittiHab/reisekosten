{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Oeffentliche = require './Oeffentliche'
Privat = require './Privat'
Verpflegung = require './Verpflegung'
Reisemittel = require './Reisemittel'

class Station

  constructor: (@reason = '', @text = '', @location = '', @inland = true) ->
    @entryDate = null
    @exitDate = null
    @verpflegung = []
    @transportations = []

  setEntryDate: (entryDate) => @entryDate = entryDate

  setExitDate: (exitDate) => @exitDate = exitDate

  setReason: (reason) => @reason = reason

  setText: (text) => @text = text

  setLocation: (location) => @location = location

  setInland: (inland) => @inland = inland

  addVerpflegung: (verpflegung = null) =>
    if not verpflegung?
      verpflegung = new Verpflegung 0, 0, 0, false, false, false
    addItem @, 'verpflegung', verpflegung

  removeVerpflegung: (verpflegung) => removeItem @, 'verpflegung', verpflegung

  addTransport: (transport = null, publicTransport = false) =>
    if not transport?
      transport = if publicTransport then new Oeffentliche '', 0 else new Privat '', 0, false, 0
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

    return station

module.exports = Station