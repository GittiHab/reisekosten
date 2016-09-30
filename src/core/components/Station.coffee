{addItem, removeItem} = require '../arrayManager'
mergeData = require '../mergeObjects'
Oeffentliche = require './Oeffentliche'
Privat = require './Privat'
Verpflegung = require './Verpflegung'
Reisemittel = require './Reisemittel'
getDates = require '../getDates'
Date.prototype.addDays = require '../addDays'
Date.prototype.resetTime = require '../resetTime'

class Station

  constructor: (@reason = '', @text = '', @city = '', @country = 'Deutschland', @inland = true) ->
    defaultDate = new Date()

    @_entryDate = defaultDate.resetTime()
    @exitDate = null
    @verpflegung = []
    @transportations = []

  setEntryDate: (entryDate) => @_entryDate = entryDate

  # @param [Boolean] asKey If the country should made uppercase and special chars removed
  # @returns [String] The country where this station lies in
  getCountry: (asKey = false) => if asKey then @country.toUpperCase().replace(/(?:\W)/g, '') else @country

  generateVerpflegung: () ->
    if not @_entryDate? or not @exitDate?
      return
    days = getDates @_entryDate, @exitDate
    # remove unneeded
    times = days.map (day) -> day.getTime()
    remove = []
    for flat in @verpflegung
      if times.indexOf(flat.getFrom().getTime()) < 0
        remove.push flat
      else
        @_setEndDate flat
    for flat in remove
      @removeVerpflegung flat
    # add new
    for day in days
      if not @_containsDate day
        flat = new Verpflegung
        flat.setFrom day.resetTime()
        @_setEndDate flat
        @verpflegung.push flat
    # Set start and end time
    @_setTime @verpflegung[0].from, @_entryDate.getHours(), @_entryDate.getMinutes()
    @_setTime @verpflegung[@verpflegung.length - 1].to, @exitDate.getHours(), @exitDate.getMinutes()

  _setEndDate: (flat) =>
    endDate = @exitDate.addDays 1
    flat.setTo endDate.resetTime()
    return flat

  _setTime: (date, hours, minutes) ->
    date.setHours hours
    date.setMinutes minutes

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
        @exitDate = new Date (@_entryDate.getTime() + 1000 * 3600 * 24)
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

  # Calculate the total transportation cost you receive back
  # @param [Boolean] includeRates If to already include the default/saved rates values. If false placeholders are used.
  #   Placeholders:
  #     - {{pkw.km}} The kilometer rate for (own) cars
  #     - {{mc.km}} The kilometer rate for (own) motorcycles
  #     - {{pkw.business.km}} The rate for business cars
  #     - {{mc.business.km}} The rate for business motorcycles
  calculateTransport: (includeRates = true) =>
    total = if includeRates then 0 else ''
    for transport, i in @transportations
      total += transport.getAmountBack not includeRates
      if not includeRates and i isnt @transportations.length - 1 then total += '+'
    return total

  # Calculate the total flat you should receive for the given flats
  # @param [Boolean] includeFlats If to already include the default/saved flat values. If false placeholders are used.
  #   Placeholders:
  #     - {{COUNTRY.fd}} The full day flat for the country, where COUNTRY will be the country name
  #     - {{COUNTRY.hd}} The half day flat for the country
  calculateFlats: (includeFlats = true) =>
    total = if includeFlats then 0 else ''
    for flat, i in @verpflegung
      total += flat.getAmountBack @getCountry(true), not includeFlats
      if not includeFlats and i isnt @verpflegung.length - 1 then total += '+'
    return total

  # Calculate all tax paid while using transports
  getTransportTax: =>
    tax = 0
    for transport in @transportations
      tax += transport.getTax()
    return tax

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

    # backwards compatibility
    if data['entryDate']?
      data['_entryDate'] = data['entryDate']
      delete data['entryDate']

    # merge in own data
    mergeData station, data

    station.createDates()

    return station

  createDates: () ->
    @setEntryDate new Date Date.parse @_entryDate
    @setExitDate new Date Date.parse @exitDate

module.exports = Station