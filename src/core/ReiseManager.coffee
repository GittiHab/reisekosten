fs = require 'fs'
Reise = require './components/Reise'
class ReiseManager

  constructor: (@path) ->
    @reisen = []

  add: (reise) =>
    @reisen.push reise
    return

  remove: (reise) =>
    index = @reisen.indexOf reise
    @reisen.slice index, 1
    return

  save: (reise = null, callback = null) =>
    promises = []
    if reise?
      promises.push (@_saveReise reise)
    else
      for reise in @reisen
        promises.push (@_saveReise reise)
    if callback?
      Promise.all(promises).then callback
    return

  _saveReise: (reise) =>
    path = @path + '/' + @reisen.indexOf(reise) + '_' + reise.getTitle() + '.json'
    fs.writeFile path, JSON.stringify reise

  open: (path) => # TODO open a travel

  moveTo: (path) => # TODO

  setPath: (path) => @path = path

  getPath: () => @path

  # Open an existing project and load data from there
  # @param [String] path The path to the projects which files should be loaded
  # @return [ReiseManager] The manager for this project with all the data
  @openProject: (path) ->
    manager = if fs.existsSync path + '/settings.json' then @_openProject path else @_createProject path
    return manager

  @_openProject: (path) ->
    manager = new ReiseManager path
    files = fs.readdirSync path
    files = files.filter (filename) -> filename.endsWith '.json'
    for filename in files
      if filename.indexOf('_') < 0
        continue
      data = fs.readFileSync path + '/' + filename
      data = JSON.parse data
      manager.add Reise.createFromData data
    return manager

  # Create a new project and store data at path
  # @param [String] path The path where the project data should be stored
  # @return [ReiseManager] The manager for this project
  @_createProject: (path) ->
    fs.writeFileSync path + '/settings.json', '{"version": "0.9.0"}'
    return new ReiseManager path

module.exports = ReiseManager