angular.module('common.filters.nullToUndefined', [])
.filter('nullToUndefined', [() ->
    (input) ->
        if input?
            return input
])
