# Test description
Reise = require '../../src/core/components/Reise'
Station = require '../../src/core/components/Station'

chai = require 'chai'
expect = chai.expect

describe 'Reise', () ->
  it 'should manage stations', () ->
    reise = new Reise 'My Travel'
    station = new Station 'Reason', '', 'Germany'
    reise.addStation station
    expect(reise.stations.length).to.equal 4
    reise.removeStation station
    expect(reise.stations.length).to.equal 3
    reise.removeStation reise.stations[0]
    expect(reise.stations.length).to.equal 3

  it 'should return the correct countries', ->
    reise = new Reise ''
    reise.stations = [
      {getCountry: -> 'Deutschland'}
      {getCountry: -> 'China'}
      {getCountry: -> 'Japan'}
      {getCountry: -> 'Korea'}
      {getCountry: -> 'Deutschland'}
      ]
    expect(reise.getCountries()).to.eql ['Deutschland', 'China', 'Japan', 'Korea', 'Deutschland']
