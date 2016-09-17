{addItem, removeItem} = require './arrayManager'

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

  addVerpflegung: (verpflegung) => addItem @, 'verpflegung', verpflegung

  removeVerpflegung: (verpflegung) => removeItem @, 'verpflegung', verpflegung

  addTransport: (transport) => addItem @, 'transportations', transport

  removeTransport: (transport) => removeItem @, 'transportations', transport


module.exports = Station