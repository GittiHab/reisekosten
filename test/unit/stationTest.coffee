# Test if the station class works as expected
Station = require '../../src/core/components/Station'

chai = require 'chai'
expect = chai.expect

generateMockTransports = (size) ->
  mocks = []
  for i in [1..size]
    mock =
      getAmountBack: (placeholder) ->
        if placeholder
          '20*{{pkw.km}}'
        else
          5
    mocks.push mock
  return mocks

describe 'Station', () ->
  it 'should calculate the transportation costs correctly', () ->
    s = new Station
    s.transportations = generateMockTransports 3
    expect(s.calculateTransport false).to.equal '20*{{pkw.km}}+20*{{pkw.km}}+20*{{pkw.km}}'
    expect(s.calculateTransport true).to.equal 15

  it 'should return the correct country', ->
    s = new Station
    s.country = 'China'
    expect(s.getCountry()).to.equal 'China'