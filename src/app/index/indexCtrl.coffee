name = 'index.indexCtrl'

angular.module(name, []).controller(name, [
	'$log'
	'$scope'
	'common.services.env'
    'common.services.authService'
    'common.services.gdriveService'
	($log, $scope, envSvc, authService, gdrive) ->
        $scope.env = envSvc.env
        $scope.gdrive = gdrive
	])