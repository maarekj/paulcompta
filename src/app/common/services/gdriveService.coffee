###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.gdriveService'

class GdriveService
    constructor: (@$http, @authService, @env, @_) ->
        @loadUrl = "/load?token=#{@authService.getAccessToken()}"
        @saveUrl = "/save?token=#{@authService.getAccessToken()}"
        
        @resolveCallback = (defer) ->
            (data) ->
                defer.$resolve data

        @rejectCallback = (defer) ->
            (data) ->
                defer.$reject data

    load: () ->
        @$http.get(@loadUrl)
        .success(@resolveCallback(deferredData))
        .error(@reject(deferredData));
                
    save: (weeks) ->
        req = @$http.post(@saveUrl, {weeks: weeks})
        .success(@resolveCallback(deferredData))
        .error(@reject(deferredData));

angular.module(name, []).factory(name, ['$http', 'common.services.authService', 'common.services.env', 'underscore', ($http, authService, env, underscore) ->
	new GdriveService($http, authService, env, underscore, )
])