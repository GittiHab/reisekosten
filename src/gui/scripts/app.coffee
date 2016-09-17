require 'angular'
require 'angular-ui-router'
{Reise, Station, Verpflegung} = require '../../core'

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
  $scope.adding = false
  $scope.addTravel = -> $scope.adding = true

app.controller 'reisenController', ->
  @reisen = [{title: 'Meine erste Reise'}, {title: 'Zweite Reise'}]
  @title = 'Willkommen'
  return

app.controller 'menuController', ->
  @open = false
  @toggleMenu = ->
    @open = !@open
  @elements = [{title: 'Einstellungen'}, {title: 'Speicherort'}, {title: 'Über'}]
  return

app.controller 'addController', ($scope) ->
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
  @currentTemplate = -> 'add-steps/' + @steps[@step].template + '.html'
  @goTo = (index) -> @step = index
  @isStep = (index) -> @step is index
  @next = ->
    if @isLast()
      #save
      # TODO
      $scope.adding = false
      return
    @goTo(++@step)
  @prev = ->
    if @isFirst()
      # cancel
      $scope.adding = false
      return
    @goTo(--@step)
  @isLast = -> @step is @steps.length - 1
  @isFirst = -> @step is 0

  @travel = new Reise ''
  @setTitle = (title) ->
      @travel.setTitle title
  return

app.directive '
    }menu', ->
  return templateUrl: 'menu.html', controller: 'menuController', controllerAs: 'menu'

app.directive 'add', ->
  return templateUrl: 'add.html', controller: 'addController', controllerAs: 'adder'