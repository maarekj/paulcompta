name = 'navbar.navbarCtrl'

angular.module(name, []).controller(name, [
    '$scope',
    'common.services.authService',
    ($scope, authService) ->
        $scope.name = name
        $scope.isConnected = () ->
            return authService.isConnected()

        $scope.deconnect = () ->
            authService.deconnect()
    ])