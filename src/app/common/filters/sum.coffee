angular.module('common.filters.sum', [])
.filter('sum', ['underscore', (_) ->
    (input) ->
        if angular.isArray(input)
            _.reduce(input, (acc, e) -> 
               acc + e
            0)
        else
            0
        
])
