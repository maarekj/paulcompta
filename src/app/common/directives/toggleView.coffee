angular.module('common.directives.toggleView', [])
.directive('toggleView', [() ->
    return {
        restrict: 'EA'
        link: ($scope, $elm, $attr, transcludeFn) ->
            primary = $elm.find('.primary')
            secondary = $elm.find('.secondary')

            primary.show()
            secondary.hide()

            isShowing = false
            $elm.on 'dblclick', (event) ->
                if isShowing
                    secondary.hide()
                    primary.show()
                else
                    secondary.show()
                    primary.hide()
                isShowing = !isShowing
    }
])
