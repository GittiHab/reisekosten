fs = require 'fs'
pathFs = require 'path'
Reise = require './components/Reise'

class ReiseManager

  constructor: (@path) ->
    @reisen = {}
    @number = 0

  add: (reise) =>
    @number++
    year = reise.getStart().getFullYear()
    @_addToYear year, reise
    if reise.getId() is 0
      reise.generateId year + '_' + (@reisen[year].indexOf(reise) + 1)
    if reise.getNumber() is 0
      reise.setNumber @number
    return

  _addToYear: (year, reise) =>
    @reisen[year] ?= []
    @reisen[year].push reise
    return

  removei: (year, reiseIndex) =>
    @_deleteReise @reisen[year][reiseIndex]
    @reisen[year].splice reiseIndex, 1
    @_cleanup()
    return

  remove: (reise) =>
    year = reise.getStart().getFullYear()
    index = @reisen[year].indexOf reise
    @removei year, index
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
    # move to correct year
    oldYear = reise.getOldStart().getFullYear()
    year = reise.getStart().getFullYear()
    if oldYear isnt year
      @_addToYear year, reise
      @removei oldYear, @reisen[oldYear].indexOf(reise)
      @_cleanup()
    # write file
    fs.writeFile @_pathToReise(reise), JSON.stringify reise

  _deleteReise: (reise) =>
    fs.unlinkSync @_pathToReise(reise), JSON.stringify reise

  _pathToReise: (reise) => @path + pathFs.sep + 'Travel_' + reise.getId() + '.json'

  _cleanup: () ->
    for year, reisen of @reisen
      if reisen.length < 1
        delete @reisen[year]

  open: (path) => # TODO open a travel

  moveTo: (path) => # TODO

  setPath: (path) => @path = path

  getPath: () => @path

  # Open an existing project and load data from there
  # @param [String] path The path to the projects which files should be loaded
  # @return [ReiseManager] The manager for this project with all the data
  @openProject: (path) ->
    manager = if fs.existsSync path + pathFs.sep + 'settings.json' then @_openProject path else @_createProject path
    return manager

  @_openProject: (path) ->
    manager = new ReiseManager path
    files = fs.readdirSync path
    files = files.filter (filename) -> filename.endsWith '.json'
    for filename in files
      if filename.indexOf('_') < 0
        continue
      data = fs.readFileSync path + pathFs.sep + filename
      data = JSON.parse data
      manager.add Reise.createFromData data
    return manager

  # Create a new project and store data at path
  # @param [String] path The path where the project data should be stored
  # @return [ReiseManager] The manager for this project
  @_createProject: (path) ->
    fs.writeFileSync path + pathFs.sep + 'settings.json', '{"version": "0.9.0"}'
    return new ReiseManager path

module.exports = ReiseManager