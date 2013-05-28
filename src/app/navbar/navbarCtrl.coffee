name = 'navbar.navbarCtrl'

angular.module(name, []).controller(name, [
    '$scope',
    'common.services.authService',
    'common.services.gdriveService',
    'common.services.weeksRepo'
    ($scope, authService, gdrive, weeksRepo) ->
        $scope.name = name
        $scope.isConnected = () ->
            return authService.isConnected()

        $scope.deconnect = () ->
            authService.deconnect()
            
        $scope.save = () ->
            gdrive.save(weeksRepo.getAll())

    ])