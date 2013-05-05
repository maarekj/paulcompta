name = 'navbar.navbarCtrl'

angular.module(name, []).controller(name, [
   '$scope',
   ($scope) ->
      $scope.name = name
   ])