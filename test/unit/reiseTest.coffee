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
    expect(reise.stations.length).to.equal 1
    reise.removeStation station
    expect(reise.stations.length).to.equal 1
    stations = []
    for i in [1..4]
      newStation = new Station '', '', ''
      reise.addStation newStation
      stations.push newStation
    expect(reise.stations.length).to.equal 5
    reise.removeStation stations[0]
    expect(reise.stations.length).to.equal 4
