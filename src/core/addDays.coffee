Date.prototype.addDays = (days) ->
  dat = new Date this.valueOf()
  dat.setDate(dat.getDate() + days)
  return dat

module.exports = Date.prototype.addDays