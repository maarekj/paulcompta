###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.gdriveService'

class GdriveService
    constructor: (@$http, @authService, @env, @_, @deferredData, @$rootScope, @weeksRepo) ->
        @loadUrl = "/load?token=#{@authService.getAccessToken()}"
        @saveUrl = "/save?token=#{@authService.getAccessToken()}"

        @loading = false
        @load()
        @$rootScope.$on 'connected', (event, accessToken) =>
            @load()
        
    load: () ->
        @loading = true;
        defer = @deferredData.typeObject();
        @$http.get(@loadUrl)
        .success((data) =>
            for week in data.weeks
                @weeksRepo.add(week)
            @loading = false
            defer.$resolve data
        )
        .error((data) =>
            @loading = false
            defer.$reject data
        )
        return defer
                
    save: (weeks) ->
        defer = @deferredData.typeObject();
        @loading = true
        @$rootScope.$broadcast('saving', @);
        
        req = @$http.post(@saveUrl, {weeks: weeks})
        .success((data) =>
            @loading = false
            @$rootScope.$broadcast('saveSuccess', @)
            defer.$resolve data
        )
        .error((data) =>
            @loading = false
            @$rootScope.$broadcast('saveError', @)
            defer.$reject data
        )

        return defer

angular.module(name, []).factory(name, ['$http', 'common.services.authService', 'common.services.env', 'underscore', 'common.services.deferredData', '$rootScope', 'common.services.weeksRepo', ($http, authService, env, underscore, deferredData, $rootScope, weeksRepo) ->
	new GdriveService($http, authService, env, underscore, deferredData, $rootScope, weeksRepo)
])