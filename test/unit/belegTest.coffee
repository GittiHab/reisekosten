# Test if bills calculate everything correctly
Beleg = require '../../src/core/components/Beleg'

chai = require 'chai'
expect = chai.expect

describe 'Belege', () ->
  it 'should calculate the tax correctly', ->
    b1 = new Beleg 0, 19, '', 200
    expect(b1.getTaxAmount()).to.equal 31.93
    b2 = new Beleg 0, 7, '', 107
    expect(b2.getTaxAmount()).to.equal 7

  it 'should return the correct amount', ->
    b1 = new Beleg 0, 0, '', 100, 'USD', 92
    expect(b1.getAmountBack()).to.equal 92
    b2 = new Beleg 0, 0, '', 100
    expect(b2.getAmountBack()).to.equal 100