Date.prototype.resetTime = () ->
  @setHours 0
  @setMinutes 0
  @setSeconds 0
  @setMilliseconds 0
  return @

module.exports = Date.prototype.resetTime