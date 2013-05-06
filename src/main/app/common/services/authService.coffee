name = 'common.services.authService'

class AuthService
    constructor: (@$log, @$location, @$env) ->
        @access_token = null
        
    runAtStart: () -> 
        matches = @$location.path().match(/access_token=([^&]+)/)
        @access_token = matches[1] if (matches?[1]?) 
        
    isConnect: () ->
        return @access_token?
    getAccessToken: () ->
        return @access_token

angular.module(name, []).factory(name, ['$log', '$location', 'common.services.env', ($log, $location, env) ->
	new AuthService($log, $location, env)
])
        