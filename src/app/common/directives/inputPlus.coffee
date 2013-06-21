angular.module('common.directives.inputPlus', [])
.directive('inputPlus', [($window) ->
    return {
        restrict: 'E',
        template: 'joseph'
        replace: true,
        require: '?ngModel',
        link: ($scope, elem, attr, controller) ->
            old = null;
            $scope.old = () ->
                if (old == null)
                    old = controller.$viewValue;
                return old;
      
            $scope.add = 0;

            $scope.$watch 'add', (newValue, oldValue) ->
                controller.$setViewValue($scope.old() + newValue);
    }
])