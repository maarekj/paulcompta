name = 'profits.profitsViewCtrl'

angular.module(name, []).controller(name, [
    '$scope'
    'common.services.weeksRepo'
    'underscore'
    '$filter'
    ($scope, weeksRepo, _, $filter) ->
        $scope.selectedYear = (new Date()).getFullYear()

        $scope.changeYear = (newYear) =>
            $scope.selectedYear = newYear

        $scope.weeksCount = () -> weeksRepo.count()

        refresh = () ->
            $scope.years = weeksRepo.getYears()
            stats = weeksRepo.getStatsByYear($scope.selectedYear)
            $scope.stats = stats.splice(0, stats.length - 1)
            $scope.totals = stats.splice(-1)[0]

        $scope.$watch "weeksCount()", refresh
        $scope.$watch "selectedYear", refresh


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


