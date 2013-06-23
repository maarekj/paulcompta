name = 'profits.profitsViewCtrl'

angular.module(name, []).controller(name, [
    '$scope'
    'common.services.weeksRepo'
    'underscore'
    '$filter'
    ($scope, weeksRepo, _, $filter) ->
        $scope.weeksCount = () -> weeksRepo.count()
        $scope.$watch "weeksCount()", () ->
            stats = weeksRepo.getStats()
            $scope.stats = stats.splice(0, stats.length - 1)
            $scope.totals = stats.splice(-1)[0]

        dateFilter = $filter('date')
        $scope.$watch "stats", () ->
            data = [['Semaine', "Chiffre d'affaire", 'Charges', 'Bénéfices']]
            for stats in $scope.stats
                data.push [
                    dateFilter stats.week
                    Math.floor stats.totalSales
                    Math.floor stats.totalCharges
                    Math.floor stats.profits
                ]
            $scope.data = data
        , true
	])


