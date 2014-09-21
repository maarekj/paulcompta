nameListCtrl = 'charges.chargesListViewCtrl'
nameListEditCtrl = 'charges.chargesListEditViewCtrl'
nameEditCtrl = 'charges.chargeEditViewCtrl'

class ChargesCtrlUtils
    constructor: (@scope, @weeksRepo) ->
    init: () ->
        @scope.selectedYear = 2014

        filterWeeks = () =>
            @scope.weeksFiltered = @weeksRepo.filterByYear(@scope.weeks, @scope.selectedYear)
            @scope.totalChange++

        @scope.changeYear = (newYear) =>
            @scope.selectedYear = newYear
            filterWeeks()

        @scope.weeksCount = () => @weeksRepo.count()
        @scope.$watch "weeksCount()", () =>
            @scope.weeks = @weeksRepo.getAll()
            @scope.years = @weeksRepo.getYears()
            @scope.chargesItems = @weeksRepo.getChargesItems()
            filterWeeks()

        @scope.totalAll = () => @weeksRepo.getTotalAllChargeByYear(@scope.selectedYear)

        @scope.getTotalOfCharge = (week) =>
            return @weeksRepo.getTotalOfCharge(week)

angular.module(nameListCtrl, []).controller(nameListCtrl, [
    '$scope'
    '$routeParams'
    'common.services.weeksRepo'
    'common.services.gdriveService'
    ($scope, $routeParams, weeksRepo, gdrive) ->
        utils = new ChargesCtrlUtils($scope, weeksRepo)
        utils.init()

        $scope.getTotalForCharge = (charge) ->
            return weeksRepo.getTotalForChargeByYear(charge, $scope.selectedYear)
])


angular.module(nameListEditCtrl, []).controller(nameListEditCtrl, [
    '$scope'
    '$window'
    '$location'
    'common.services.weeksRepo'
    ($scope, $window, $location, weeksRepo) ->
        utils = new ChargesCtrlUtils($scope, weeksRepo)
        utils.init()

        $scope.removeChargeAtIndex = (index) ->
            if ($window.confirm('Voulez-vous vraiment supprimé la ligne ?'))
                weeksRepo.removeAtIndex(index)

        $scope.editChargeAtIndex = (index) ->
            $location.path("/charges/edit/#{index}")

        $scope.addCharge = () ->
            $location.path('/charges/new')
])

angular.module(nameEditCtrl, []).controller(nameEditCtrl, [
    '$scope'
    '$window'
    '$location'
    '$routeParams'
    'common.services.weeksRepo'
    ($scope, $window, $location, $routeParams, weeksRepo) ->

        $scope.weeksCount = () -> weeksRepo.count()
        $scope.$watch "weeksCount()", () ->
            $scope.chargesItems = weeksRepo.getChargesItems()

        index = $routeParams.index
        if index?
            $scope.isNew = false
            $scope.week = weeksRepo.get(index)
        else
            $scope.isNew = true
            $scope.week = weeksRepo.create()

        $scope.getTotal = () ->
            return weeksRepo.getTotalOfCharge($scope.week)

        $scope.addChargeItem = () ->
            item = $window.prompt('Quel est le nom du poste de dépense à ajouter ?')
            $scope.chargesItems.push(item) if item

        $scope.save = () ->
            if ($scope.isNew)
                weeksRepo.add($scope.week)
            else
                weeksRepo.save(index, $scope.week)

            $location.path('/charges/edit')

        $scope.cancel = () ->
            $location.path('/charges/edit')
])


