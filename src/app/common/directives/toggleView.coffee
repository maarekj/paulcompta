angular.module('common.directives.toggleView', [])
.directive('toggleView', [() ->
    return {
        restrict: 'EA'
        link: ($scope, $elm, $attr, transcludeFn) ->
            primary = $elm.find('.primary')
            secondary = $elm.find('.secondary')
            
            if primary.length == 0
                primary = $elm

            secondary.hide()

            isShowing = false
            primary.on 'dblclick', (event) ->                
                if isShowing
                    secondary.hide()
                else
                    secondary.show()
                isShowing = !isShowing
    }
])
