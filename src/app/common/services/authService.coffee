name = 'common.services.authService'

class AuthService
    constructor: (@$window, @$log, @$rootScope, @$cookieStore, @$location, @$env) ->
        @accessToken = null
        
    runAtStart: () -> 
        matches = @$location.path().match(/access_token=([^&]+)/)
        accessToken = matches[1] if matches?[1]?
        
        matches = @$location.path().match(/expires_in=([^&]+)/)
        expiresIn = matches[1] if matches?[1]?
        
        @setAccessToken(accessToken, expiresIn) if accessToken
        
        @$rootScope.$on '$routeChangeStart', (event, next, current) =>
            if not @isConnected() and next.templateUrl isnt '/loginView/loginView.html'
                @$location.path('/login')

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
        date = new Date();
        date.setTime(date.getTime() + (expiresIn * 1000));

        @accessToken = accessToken
        @accessTokenExpiresIn = date

        expires = "; expires=#{@accessTokenExpiresIn.toGMTString()}";
        @$window.document.cookie = "#{name}.cookies.accessToken=\"#{@accessToken}\"; expires=#{@accessTokenExpiresIn.toGMTString()}; path=/"

angular.module(name, []).factory(name, ['$window', '$log', '$rootScope', '$cookieStore', '$location', 'common.services.env', ($window, $log, $rootScope, $cookieStore, $location, env) ->
	new AuthService($window, $log, $rootScope, $cookieStore, $location, env)
])