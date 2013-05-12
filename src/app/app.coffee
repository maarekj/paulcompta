### ###########################################################################
# Wire modules together
### ###########################################################################

mods = [
    'ngCookies'
    'common.services.authService'
    'common.services.envProvider'
    
    'common.services.gdriveService'
    'common.services.weeksRepo'
    'underscore'
    
    'login.loginViewCtrl'
    'charges.chargesListViewCtrl'
    'charges.chargesListEditViewCtrl'
    'charges.chargeEditViewCtrl'

    'navbar.navbarCtrl'
    'index.indexCtrl'
]

### ###########################################################################
# Declare routes 
### ###########################################################################

routesConfigFn = ($routeProvider)->
    $routeProvider.when('/login',
        {templateUrl: '/login/loginView.html'})

    $routeProvider.when('/',
        {templateUrl: '/charges/chargesListView.html'})
    $routeProvider.when('/charges',
        {redirectTo: '/'})
    $routeProvider.when('/charges/edit',
        {templateUrl: '/charges/chargesListEditView.html'})
    $routeProvider.when('/charges/new',
        {templateUrl: '/charges/chargeEditView.html'})
    $routeProvider.when('/charges/edit/:index',
        {templateUrl: '/charges/chargeEditView.html'})
        

    $routeProvider.otherwise({redirectTo: '/'})

### ###########################################################################
# Create and bootstrap app module
### ###########################################################################
    
m = angular.module('app', mods)

m.config ['$routeProvider', routesConfigFn]

m.config (['common.services.envProvider', (envProvider)->

    # Allows the environment provider to run whatever config block it wants.
    if envProvider.appConfig?
        envProvider.appConfig()
])

m.run (['common.services.env', 'common.services.authService', (env, authService)->

    # Allows the environment service to run whatever app run block it wants.
    if env.appRun?
        env.appRun()
        
    authService.runAtStart()
])

angular.element(document).ready ()->
    angular.bootstrap(document,['app'])