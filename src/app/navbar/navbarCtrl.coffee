name = 'navbar.navbarCtrl'

angular.module(name, []).controller(name, [
    '$scope',
    '$rootScope',
    '$location',
    'common.services.authService',
    'common.services.gdriveService',
    'common.services.weeksRepo'
    ($scope, $rootScope, $location, authService, gdrive, weeksRepo) ->
        $scope.name = name
        $scope.isConnected = () ->
            return authService.isConnected()

        $scope.deconnect = () ->
            authService.deconnect()
            
        $scope.save = () ->
            gdrive.save(weeksRepo.getAll())

        $scope.location = $location.path()

        $rootScope.$on '$locationChangeSuccess', (newUrl, oldUrl) =>
            $scope.location = $location.path()
    ])