###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.gdriveService'

class GdriveService
    constructor: (@$log, @$http, @authService, @env, @_) ->
        @fileAppDataUrl = "/google/files/appdata?token=#{@authService.getAccessToken()}"
        @saveUrl = "/save?token=#{@authService.getAccessToken()}"

    files: (callback) ->
        @$http.get(@fileAppDataUrl)
        .success(callback)

    save: (weeks, callback) ->
        req = @$http.post(@saveUrl, {weeks: weeks})
        req.success(callback) if callback

angular.module(name, []).factory(name, ['$log', '$http', 'common.services.authService', 'common.services.env', 'underscore', ($log, $http, authService, env, underscore) ->
	new GdriveService($log, $http, authService, env, underscore)
])