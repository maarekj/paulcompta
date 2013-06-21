nameListCtrl = 'sales.salesListViewCtrl'
nameListEditCtrl = 'sales.salesListEditViewCtrl'

class SalesCtrlUtils
    constructor: (@scope, @weeksRepo, @_) ->

    init: () ->
        @scope.weeksCount = () => @weeksRepo.count()
        @scope.$watch "weeksCount()", () =>
            @scope.weeks = @weeksRepo.getAll()
        
        cache = {}
        @scope.totalChange = 0
        add = (acc, e) -> acc + e
        sum = (input) => @_.reduce input, add, 0

        totalWithCache = (week, withCache) =>
            if withCache && cache[week.week]?
                return cache[week.week]
            total = sum week.sales
            @scope.totalChange++ if total != cache[week.week]
            cache[week.week] = total
            return total

        @scope.total = (week) =>
            totalWithCache week, false

        @scope.totalAll = 0
        @scope.$watch "totalChange", () =>
            totals = (totalWithCache week, true for week in @scope.weeks)
            @scope.totalAll = sum totals

angular.module(nameListCtrl, []).controller(nameListCtrl, [
    '$scope'
    'common.services.weeksRepo'
    'common.services.gdriveService'
    'underscore'
    ($scope, weeksRepo, gdrive, _) ->
        utils = new SalesCtrlUtils($scope, weeksRepo, _)
        utils.init()
	])
    
angular.module(nameListEditCtrl, []).controller(nameListEditCtrl, [
    '$scope'
    '$window'
    '$location'
    'common.services.weeksRepo'
    'underscore'
    ($scope, $window, $location, weeksRepo, _) ->
        utils = new SalesCtrlUtils($scope, weeksRepo, _)
        utils.init()

        #$scope.removeChargeAtIndex = (index) ->
        #    if ($window.confirm('Voulez-vous vraiment supprimé la ligne ?'))
        #        weeksRepo.removeAtIndex(index)

        #$scope.editChargeAtIndex = (index) ->
        #    $location.path("/charges/edit/#{index}")

        #$scope.addCharge = () ->
        #    $location.path('/charges/new')
	])

