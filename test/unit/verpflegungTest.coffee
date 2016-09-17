# Test if the class Verpflegung works as expected
Verpflegung = require '../../src/core/components/Verpflegung'
chai = require 'chai'
expect = chai.expect

describe 'Verpflegung', () ->
  it 'should calculate the correct flat', () ->
    rate =
      fullday: 40
      halfday: 24
    from = new Date Date.parse('December 24, 2015 00:00:00')
    to = new Date Date.parse('December 24, 2015 09:00:00')

    verpflegung = new Verpflegung rate, from, to, true, true, true
    expect(verpflegung.getFlat()).to.equal 24
    verpflegung.setTo new Date Date.parse('December 25, 2015 00:00:00')
    expect(verpflegung.getFlat()).to.equal 40
    verpflegung.setTo new Date Date.parse('December 24, 2015 07:59:59')
    expect(verpflegung.getFlat()).to.equal 0