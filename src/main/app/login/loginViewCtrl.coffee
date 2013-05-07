name = 'login.loginViewCtrl'

angular.module(name, []).controller(name, [
	'$scope'
	'common.services.authService'
    'common.services.env'
	($scope, authService, env) ->
        $scope.authUrl = env.google.authUrl
	])