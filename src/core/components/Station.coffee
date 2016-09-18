{addItem, removeItem} = require './arrayManager'
Oeffentliche = require './Oeffentliche'
Privat = require './Privat'
Verpflegung = require './Verpflegung'

class Station

  constructor: (@reason, @text, @location, @inland = true) ->
    @entryDate = null
    @exitDate = null
    @verpflegung = []
    @transportations = []

  setEntryDate: (entryDate) => @entryDate = entryDate

  setExitDate: (exitDate) => @exitDate = exitDate

  setReason: (reason) => @reason = reason

  setText: (text) => @text = text

  setLocation: (location) => @location = location

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


module.exports = Station