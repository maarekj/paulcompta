###
DEV
###
providerName = 'common.services.env' # angular adds the 'Provider' suffix for us.
modName = "#{providerName}Provider"

class Environment
    env: 'DEV'

    constructor: (@$log, @google)->

    appRun: ()->
        @$log.log ("Running custom 'run'-time initialization of the main app module")

class EnvironmentProvider
    constructor: () ->
        @google = {}
        
        @google.clientId = '@@ENV_GOOGLE_CLIENT_ID'
        @google.scope = 'https://www.googleapis.com/auth/drive.appdata'
            
        @google.baseUrl = 'https://accounts.google.com/o/oauth2'
        @google.redirectUri = '@@ENV_GOOGLE_REDIRECT_URI'
        @google.authUrl = "#{@google.baseUrl}/auth?scope=#{@google.scope}&response_type=token&client_id=#{@google.clientId}&redirect_uri=#{@google.redirectUri}"

    $get: ['$log', ($log)->
                new Environment($log, @google)
    ]

    appConfig: ()->
        # using console because there's no 'log' object yet
        console.log("Running custom 'config'-time initialization of the main app module")

# note that we have to include the module names of our dependencies here since the main app
# modules won't know about them
mod = angular.module(modName, [])
mod.provider(providerName, new EnvironmentProvider())

