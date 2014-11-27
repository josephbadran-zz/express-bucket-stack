"use strict"

angular.module("naratusApp", [
  "ngRoute"
  "ngAnimate"
  "naratusApp.controllers"
  "naratusApp.directives"
  "naratusApp.services"
]).config(($routeProvider, $locationProvider) ->
  $routeProvider
  .when("/",
    controller: "AppCtrl"
    templateUrl: "partials/partial1"
  )
  .otherwise(redirectTo: "/")

  $locationProvider.html5Mode(true)
)
