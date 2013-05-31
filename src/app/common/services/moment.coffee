name = 'moment'

angular.module(name, []).factory('moment', ['$window', ($window) ->
    return $window.moment;
])