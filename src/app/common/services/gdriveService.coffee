###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.gdriveService'

class GdriveService
    constructor: (@$http, @authService, @env, @_, @deferredData) ->
        @loadUrl = "/load?token=#{@authService.getAccessToken()}"
        @saveUrl = "/save?token=#{@authService.getAccessToken()}"
        
        @resolveCallback = (defer) ->
            (data) ->
                defer.$resolve data

        @rejectCallback = (defer) ->
            (data) ->
                defer.$reject data

    load: () ->
        defer = @deferredData.typeObject();
        @$http.get(@loadUrl)
        .success(@resolveCallback(defer))
        .error(@rejectCallback(defer));
        return defer
                
    save: (weeks) ->
        defer = @deferredData.typeObject();
        req = @$http.post(@saveUrl, {weeks: weeks})
        .success(@resolveCallback(defer))
        .error(@rejectCallback(defer));
        return defer

angular.module(name, []).factory(name, ['$http', 'common.services.authService', 'common.services.env', 'underscore', 'common.services.deferredData', ($http, authService, env, underscore, deferredData) ->
	new GdriveService($http, authService, env, underscore, deferredData)
])