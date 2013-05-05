### ###########################################################################
# Wire modules together
### ###########################################################################

mods = [
    'common.directives.glowGreenOnMouseoverDirective'
    'common.directives.uiTooltipDirective'
    'common.filters.toLowerFilter'
    'common.services.dataSvc'
    'common.services.envProvider'
    'common.services.toastrWrapperSvc'
    
    'common.services.chargesRepo'
    'underscore'

    'detailsView.detailsViewCtrl'
    'detailsView.personDetailsDirective'
    
    'charges.chargesListViewCtrl'
    'charges.chargesListEditViewCtrl'
    'charges.chargeEditViewCtrl'

    'navbar.navbarCtrl'
    'index.indexCtrl'

    'searchView.mattizerFilter'
    'searchView.searchViewCtrl'
]

### ###########################################################################
# Declare routes 
### ###########################################################################

routesConfigFn = ($routeProvider)->

    $routeProvider.when('/search',
        {templateUrl: 'searchView/searchView.html'})
    $routeProvider.when('/details/:id',
        {templateUrl: 'detailsView/detailsView.html'})
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

m.run (['common.services.env', (env)->

    # Allows the environment service to run whatever app run block it wants.
    if env.appRun?
        env.appRun()
])

angular.element(document).ready ()->
    angular.bootstrap(document,['app'])