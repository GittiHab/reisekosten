Exporter = require './Exporter'
ExcelBuilder = require 'excel-builder'

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
        @_createCell('Belege (nur MwSt.)')
        @_createCell @flatSheetName+'!B3*5', type: 'formula'
      ]
    ]
    for travel in @data
      row = [
        @_createCell(travel.getStart())
        @_createCell(travel.getEnd())
        @_createCell(travel.getTitle())
        @_createCell(travel.serializeStations())
        @_createCell(travel.calculateTransport(false))
        @_createCell(travel.calculateFlats(false))
        @_createCell(travel.calculateBills())
      ]
      fileData.push row
      @_addCountries travel.getCountries()
    return fileData

  _addCountries: (countries = []) =>
    for country in countries
      if @countries.indexOf(country) < 0
        @countries.push country
    return

  _createDefaultStyle: (workbook) =>
    @defaultStyle = workbook.getStyleSheet().createFormat
      font:
        color: 0x0000000
        bold: true
      fill:
        type: 'pattern'
        patternType: 'solid'
        fgColor: 0xFFFFFF

  _createCell: (value, options = {}) =>
    if not options.style?
      options.style = @defaultStyle
    return {
      value: value,
      metadata: options
    }


  _fillPresetValues: =>
    flatData = []
    ## Transportations km-flat
    # PKW
    flatData.push [
      @_createCell 'PWK KM-Satz'
      @_createCell 0
    ]
    ## Day-flat
    flatData.push ['Dauer'].concat @countries
    # 24-hours
    flatData.push [@_createCell '24 Stunden']
    # 8-24hours
    flatData.push [@_createCell '8-24 Stunden']
    flatData.push [
      @_createCell 'Quellen:'
      @_createCell 'http://www.reisekostenabrechnung.com/verpflegungsmehraufwand-2015/'
    ]
    return flatData

module.exports = XLSExporter