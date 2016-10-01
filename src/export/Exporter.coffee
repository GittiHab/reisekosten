# Abstract class for exporting the data in different formats.
# Inherited by the exporters which override the methods.
class Exporter

  @detailed = 'detailed'

  @yearOverview = 'overview'

  # @param [Object] options Options for the exporter
  # @option options [String] detailLevel The level of detail to be exported. Possible values:
  #   Exporter.detailed Exports every travel with all details
  #   Exporter.yearOverview Exports a page with an overview over alls travels, theirs costs and the total costs
  constructor: (options = {}) ->
    @detailLevel = Exporter.yearOverview
    if options.detailLevel?
      @detailLevel = options.detailLevel
    return

  # Abstract method. Export the given data
  # @param [Array<Reise>] data Data to be exported
  # @return [String] The exported file contents (can be used to create a file)
  export: (data) ->
    throw new Error 'Method "export" should be overriden'
    return

  @formatDate: (date) ->
    day = date.getDate()
    month = date.getMonth()
    year = date.getFullYear()
    return "#{day}.#{month}.#{year}"

module.exports = Exporter
