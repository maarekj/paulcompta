name = 'underscore'

angular.module(name, []).factory('underscore', ['$window', ($window) ->
    return $window._;
])