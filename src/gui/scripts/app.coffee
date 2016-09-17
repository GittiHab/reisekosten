require 'angular'
require 'angular-ui-router'

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

app.directive 'menu', ->
  return templateUrl: 'menu.html', controller: 'menuController', controllerAs: 'menu'