name = 'index.indexCtrl'

angular.module(name, []).controller(name, [
	'$log'
	'$scope'
	'common.services.env'
    'common.services.authService'
	($log, $scope, envSvc, authService) ->
        $scope.env = envSvc.env
	])