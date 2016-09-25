# Test if Reisemittel does everything as expected

Privat = require '../../src/core/components/Privat'
Oeffentliche = require '../../src/core/components/Oeffentliche'

chai = require 'chai'
expect = chai.expect

describe 'Reisemittel', () ->
  it 'should return the correct amount that is received back', () ->
    r1 = new Privat '', 600, false, 0, false
    expect(r1.getAmountBack('Deutschland', true)).to.equal '600*{{pkw.km}}'
    r1 = new Privat '', 600, false, 0, true
    expect(r1.getAmountBack('Deutschland', true)).to.equal '600*{{mc.km}}'
    r1 = new Privat '', 600, true, 0, false
    expect(r1.getAmountBack('Deutschland', true)).to.equal '600*{{pkw.business.km}}'
    r1 = new Privat '', 600, true, 0, true
    expect(r1.getAmountBack('Deutschland', true)).to.equal '600*{{mc.business.km}}'

    r2 = new Oeffentliche '', 1200
    expect(r2.getAmountBack('Deutschland', true)).to.equal 1200