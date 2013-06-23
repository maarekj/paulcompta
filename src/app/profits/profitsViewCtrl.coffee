name = 'profits.profitsViewCtrl'

angular.module(name, []).controller(name, [
    '$scope'
    'common.services.weeksRepo'
    'underscore'
    ($scope, weeksRepo, _) ->
        $scope.weeksCount = () -> weeksRepo.count()
        $scope.$watch "weeksCount()", () ->
            $scope.stats = weeksRepo.getStats()            
	])


