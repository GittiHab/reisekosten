Exporter = require './Exporter'
ExcelBuilder = require 'excel-builder'
fs = require 'fs'
strToKey = require '../core/strToKey'

class XLSExporter extends Exporter

  # Creata a new XLS Exporter which can export the files to .xlsx files
  # @see Exporter.constructor
  constructor: (options = {}) ->
    super(options)
    @defaultStyle = null
    @flatSheetName = 'Pauschalen'
    @dataSheetName = 'Übersicht'

  # @see Exporter.export
  export: (data) =>
    if @detailLevel is Exporter.yearOverview
      return @_generateYearOverview data
    return ''

  # Generates an overview over all given travels
  _generateYearOverview: (data) =>
    @data = data
    @countries = []
    @countriesAsKeys = []
    @taxes = []
    workbook = new ExcelBuilder.Workbook
    @_createDefaultStyle workbook
    # Now add the data
    dataSheet = new ExcelBuilder.Worksheet {name: @dataSheetName}
    workbook.addWorksheet dataSheet
    dataSheet.setData @_fillValues @dataSheet
    # Add a sheet with all the required preset values
    valueSheet = new ExcelBuilder.Worksheet {name: @flatSheetName}
    workbook.addWorksheet valueSheet
    valueSheet.setData @_fillPresetValues()
    return ExcelBuilder.Builder.createFile workbook

  _fillValues: (worksheet) =>
    fileData = [
      [
        @_createCell('Start')
        @_createCell('Ende')
        @_createCell('Titel')
        @_createCell('Stationen')
        @_createCell('Transportkosten')
        @_createCell('Pauschalen')
        @_createCell('Sonstige')
        #        @_createCell @flatSheetName+'!B3*5', type: 'formula'
      ]
    ]
    for travel, i in @data
      @_addCountries travel.getCountries false
      row = [
        @_createCell(Exporter.formatDate travel.getStart())
        @_createCell(Exporter.formatDate travel.getEnd())
        @_createCell(travel.getTitle())
        @_createCell(travel.serializeStations())
        @_createCell(travel.calculateTransport(false), type: 'formula')
        @_createCell(travel.calculateFlats(false), type: 'formula')
        @_createCell(travel.calculateBills(), type: 'formula')
      ]
      row = @_attachTaxes row, travel.calculateTaxes()
      fileData.push row
    fileData[0] = @_appendTaxHeights fileData[0]
    return fileData

  _attachTaxes: (row, taxes) =>
    rowl = row.length
    for tax, total of taxes
      taxi = @taxes.indexOf tax
      if taxi < 0
        @taxes.push tax
        taxi = @taxes.length - 1
      row[rowl + taxi] = @_createCell total
    return row

  _appendTaxHeights: (row) =>
    for tax in @taxes
      row.push @_createCell 'MwSt. ' + tax + '%'
    return row

  _addCountries: (countries = []) =>
    for country in countries
      if @countries.indexOf(country) < 0
        @countries.push country
        @countriesAsKeys.push strToKey country
    return

  _createDefaultStyle: (workbook) =>
    @defaultStyle = workbook.getStyleSheet().createFormat
      font:
        color: 0x0000000
      fill:
        type: 'pattern'
        patternType: 'solid'
        fgColor: 0xFFFFFF

  _createCell: (value, options = {}) =>
    if not options.style?
      options.style = @defaultStyle.id
    if options.type is 'formula'
      value = @_replacePlaceholders value
    return {
      value: value,
      metadata: options
    }

  _replacePlaceholders: (value) =>
    if typeof value isnt 'string'
      return value

    _this = @
    value = value.replace('{{pkw.km}}', @flatSheetName + '!B1')
    value = value.replace(/\{\{([A-Z]+)\.(hd|fd)\}\}/g, (found, country, type) ->
      row = if type is 'hd' then 4 else 3
      abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      col = abc[_this.countriesAsKeys.indexOf(country) + 1]
      return _this.flatSheetName + '!' + col + row)
    return value

  _fillPresetValues: =>
    flatData = []
    ## Transportations km-flat
    # PKW
    flatData.push [
      @_createCell 'PWK KM-Satz'
      @_createCell 0.3
    ]
    ## Day-flat
    flatData = flatData.concat @_fillInFlats()
    return flatData

  _fillInFlats: =>
    flatData = []
    # Country titles
    flatData.push [@_createCell 'Dauer'].concat (@_createCell country for country in @countries)
    # pre-defined flats
    flats = JSON.parse (fs.readFileSync __dirname + '/../data/countries.json')
    # 24-hours
    flatData.push [@_createCell '24 Stunden'].concat (@_createCell flats[country].full for country in @countries)
    # 8-24hours
    flatData.push [@_createCell '8-24 Stunden'].concat (@_createCell flats[country].half for country in @countries)
    flatData.push [
      @_createCell 'Quellen:'
      @_createCell 'http://www.reisekostenabrechnung.com/verpflegungsmehraufwand-2015/'
    ]
    return flatData


module.exports = XLSExporter