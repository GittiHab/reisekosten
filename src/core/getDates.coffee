Date.prototype.addDays = require './addDays'

getDates = (aDate, bDate) ->
  dateArray = []
  startDate = aDate
  stopDate = bDate
  if aDate > bDate
    startDate = bDate
    stopDate = aDate
  currentDate = startDate
  while currentDate <= stopDate
    dateArray.push new Date currentDate
    currentDate = currentDate.addDays 1
  return dateArray

module.exports = getDates