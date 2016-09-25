# Test if the XLS Exporter exports correctly
XLSExporter = require '../../src/export/XLSExporter'
chai = require 'chai'
expect = chai.expect
fs = require 'fs'

# Creates fake objects to test the export
generateTestData = (size) ->
  testData = []
  for i in [1..size]
    obj =
      getStart: -> '2016.05.07'
      getEnd: -> '2016.05.08'
      getTitle: -> 'Some travel'
      serializeStations: -> 'Paris, New York, Berlin',
      getCountries: -> ['Deutschland', 'China', 'Bayern']
      calculateTransport: -> 500
      calculateFlats: -> 250
      calculateBills: -> 100

    testData.push obj
  return testData

describe 'XLSExporter', () ->
  it 'should create a correct year overview', () ->
    reisen = generateTestData 5
    exporter = new XLSExporter
    data = exporter.export reisen
    data.then (d) -> fs.writeFile 'test.xlsx', d, {encoding: 'base64'}