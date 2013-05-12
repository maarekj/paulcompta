name = 'common.services.authService'

class AuthService
    constructor: (@$log, @$rootScope, @$cookieStore, @$location, @$env) ->
        @accessToken = null
        
    runAtStart: () -> 
        matches = @$location.path().match(/access_token=([^&]+)/)
        accessToken = matches[1] if matches?[1]?
        
        matches = @$location.path().match(/expires_in=([^&]+)/)
        expiresIn = matches[1] if matches?[1]?
        
        @setAccessToken(accessToken, expiresIn) if accessToken
        
        @$rootScope.$on('$routeChangeStart', (event, next, current) =>
            if not @isConnected() and next.templateUrl isnt '/loginView/loginView.html'
                @$location.path('/login')
        )

    deconnect: () ->
        @setAccessToken(null, null)
        @$location.path('/login')

    isConnected: () ->
        return @getAccessToken()?

    getAccessToken: () ->
        if @accessToken == null
            @accessToken = @$cookieStore.get("#{name}.cookies.accessToken")
        return @accessToken
        
    setAccessToken: (accessToken, expiresIn) ->
        @accessToken = accessToken
        @accessTokenExpiresIn = expiresIn
        @$cookieStore.put("#{name}.cookies.accessToken", accessToken)

angular.module(name, []).factory(name, ['$log', '$rootScope', '$cookieStore', '$location', 'common.services.env', ($log, $rootScope, $cookieStore, $location, env) ->
	new AuthService($log, $rootScope, $cookieStore, $location, env)
])