###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.gdriveService'

class GdriveService
    constructor: (@$log, @$http, @authService, @env, @_) ->
        @baseUrl = "https://www.googleapis.com/drive/v2"
        @fileAppDataUrl = "#{@baseUrl}/files/appdata?access_token=#{@authService.getAccessToken()}&callback=JSON_CALLBACK"

    files: (callback) ->
        @$http.jsonp(@fileAppDataUrl)
        .success(callback)

angular.module(name, []).factory(name, ['$log', '$http', 'common.services.authService', 'common.services.env', 'underscore', ($log, $http, authService, env, underscore) ->
	new GdriveService($log, $http, authService, env, underscore)
])