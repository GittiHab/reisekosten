require 'angular'
require 'angular-ui-router'
{Reise, Station, Verpflegung, ReiseManager} = require '../../core'
remote = require('electron').remote
fs = require 'fs'

app = angular.module 'reisekostenabrechnung', ['ui.router']

app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
  .state 'overview',
    url: '/',
    templateUrl: 'overview.html',
    controller: 'reisenController',
    controllerAs: 'reisen'
  .state 'loading',
    url: 'loading', # should be default state in the future
    template: '<h2 style="position:absolute;top:50%;width:100%;text-align:center;' +
      'font-weight:200;font-size:20px;margin-top: -10px;">Loading...</h2>'


app.controller 'mainController', ($scope) ->
  @adding = false
  $scope.edit = null
  @openAdder = (reise = null) ->
    @adding = true
    $scope.edit = reise
  @closeAdder = () ->
    @adding = false
    $scope.manager.save()
  @isAdding = () -> @adding
  dataPath = remote.getGlobal 'DataPath'
  $scope.manager = ReiseManager.openProject dataPath
  console.log $scope.manager
  return


app.controller 'reisenController', ->
  @title = 'Willkommen'
  return

app.controller 'menuController', ->
  @open = false
  @toggleMenu = ->
    @open = !@open
  @elements = [{title: 'Einstellungen'}, {title: 'Speicherort'}, {title: 'Über'}]
  return

app.controller 'editController', ($scope) ->
  @travel = new Reise ''
  @_edit = false
  @editTravel = (reise) =>
    @_edit = true
    @travel = reise
    return

  # Setup
  if $scope.edit?
    @editTravel $scope.edit
    $scope.edit = null

  @step = 0
  @steps = [
    {
      title: 'Allgemein',
      template: 'general'
    },
    {
      title: 'Reiseroute'
      template: 'route'
    },
    {
      title: 'Verpflegung',
      template: 'flat'
    },
    {
      title: 'Belege',
      template: 'bills'
    }
  ]
  @currentTitle = -> @steps[@step].title
  @currentTemplate = -> 'edit-steps/' + @steps[@step].template + '.html'
  @goTo = (index) -> @step = index
  @isStep = (index) -> @step is index
  @next = ->
    if @isLast()
      #save
      if not @_edit then $scope.manager.add @travel
      $scope.main.closeAdder()
      return
    @goTo(++@step)
  @prev = ->
    if @isFirst()
      # cancel
      $scope.main.closeAdder()
      return
    @goTo(--@step)
  @isLast = -> @step is @steps.length - 1
  @isFirst = -> @step is 0
  return

app.directive 'menu', ->
  return templateUrl: 'menu.html', controller: 'menuController', controllerAs: 'menu'

app.directive 'add', ->
  return templateUrl: 'edit.html', controller: 'editController', controllerAs: 'adder'

app.directive 'transport', ->
  return templateUrl: 'edit-steps/transport.html'