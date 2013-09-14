### ###########################################################################
# Wire modules together
### ###########################################################################

mods = [
    'ngCookies'
    'underscore'
    'moment'

    'common.filters.sum'
    'common.filters.nullToUndefined'

    'common.directives.inputPlus'
    'common.directives.chart'
    'common.directives.toggleView'

    'common.services.deferredData'

    'common.services.authService'
    'common.services.envProvider'

    'common.services.gdriveService'
    'common.services.weeksRepo'
    
    'login.loginViewCtrl'
    'charges.chargesListViewCtrl'
    'charges.chargesListEditViewCtrl'
    'charges.chargeEditViewCtrl'
    
    'sales.salesListViewCtrl'
    'sales.salesListEditViewCtrl'
    
    'sales.paymentsListViewCtrl'
    'sales.paymentsListEditViewCtrl'
    
    'profits.profitsViewCtrl'
#    'sales.saleEditViewCtrl'

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
        
    $routeProvider.when('/sales',
        {templateUrl: '/sales/salesListView.html'})
    $routeProvider.when('/sales/edit',
        {templateUrl: '/sales/salesListEditView.html'})
        
    $routeProvider.when('/payments',
        {templateUrl: '/sales/paymentsListView.html'})
    $routeProvider.when('/payments/edit',
        {templateUrl: '/sales/paymentsListEditView.html'})
            
    $routeProvider.when('/profits',
        {templateUrl: '/profits/profitsView.html'})
        

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


google.setOnLoadCallback () ->
    angular.element(document).ready ()->
        angular.bootstrap(document,['app'])

google.load('visualization', '1', {packages: ['corechart']})