###
DEV
###
providerName = 'common.services.env' # angular adds the 'Provider' suffix for us.
modName = "#{providerName}Provider"

class Environment

    env: 'DEV'
    serverUrl: '' # blank because all $http calls will be faked

    constructor: (@$httpBackend, @$log, @hardcodedData, @google)->

    appRun: ()->
        @$log.log ("Running custom 'run'-time initialization of the main app module")
        @hardcodedData.addHardcodedData(@$httpBackend)

class EnvironmentProvider
    constructor: () ->
        @google = {}
        
        @google.clientId = '525964413214-9s58fe969e54t670gsi9pjrq2bphet6v.apps.googleusercontent.com'
        @google.scope = 'https://www.googleapis.com/auth/drive'
            
        @google.baseUrl = 'https://accounts.google.com/o/oauth2'
        @google.redirectUri = 'http://localhost:8000'
        @google.authUrl = "#{@google.baseUrl}/auth?scope=#{@google.scope}&response_type=token&client_id=#{@google.clientId}&redirect_uri=#{@google.redirectUri}"

    $get:
        [
            '$httpBackend'
            '$log'
            'common.services.harcodedDataSvc'
            ($httpBackend, $log, hardcodedData)->
                new Environment($httpBackend, $log, hardcodedData, @google)
        ]

    appConfig: ()->
        # using console because there's no 'log' object yet
        console.log("Running custom 'config'-time initialization of the main app module")

# note that we have to include the module names of our dependencies here since the main app
# modules won't know about them
mod = angular.module(modName, ['ngMockE2E', 'common.services.harcodedDataSvc'])
mod.provider(providerName, new EnvironmentProvider())

