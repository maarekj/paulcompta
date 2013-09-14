nameListCtrl = 'sales.salesListViewCtrl'
nameListEditCtrl = 'sales.salesListEditViewCtrl'

class SalesCtrlUtils
    constructor: (@scope, @weeksRepo, @_) ->

    sum: (input) ->
        add = (acc, e) ->
            acc + e
        @_.reduce input, add, 0
        
    sort: (input) ->
        cmp = (a, b) ->
            if a == b
                return 0
            else if a < b
                -1
            else
                1
        numberCmp = (a, b) -> cmp(Number(a), Number(b))
        input.sort numberCmp

    init: () ->
        @scope.weeksCount = () => @weeksRepo.count()
        @scope.$watch "weeksCount()", () =>
            @scope.weeks = @weeksRepo.getAll()
        
        cache = {}
        @scope.totalChange = 0

        totalWithCache = (week, withCache) =>
            if withCache && cache[week.week]?
                return cache[week.week]
            total = @sum week.sales
            @scope.totalChange++ if total != cache[week.week]
            cache[week.week] = total
            return total

        @scope.total = (week) =>
            totalWithCache week, false

        @scope.totalAll = 0
        @scope.$watch "totalChange", () =>
            totals = (totalWithCache week, true for week in @scope.weeks)
            @scope.totalAll = @sum totals

angular.module(nameListCtrl, []).controller(nameListCtrl, [
    '$scope'
    'common.services.weeksRepo'
    'common.services.gdriveService'
    'underscore'
    ($scope, weeksRepo, gdrive, _) ->
        utils = new SalesCtrlUtils($scope, weeksRepo, _)
        utils.init()
        
        $scope.mean = (day) ->
            days = _(week.sales[day] for week in $scope.weeks).filter((sale) -> sale and sale != 0)
            if days.length <= 0
                return 0
            sum = utils.sum days
            Math.floor(sum / days.length)
            
        $scope.median = (day) =>
            days = _(week.sales[day] for week in $scope.weeks).filter((sale) -> sale? and sale != 0)
            if days.length <= 0
                return 0

            days = utils.sort days
            median = Math.floor(days.length / 2)
            if median % 2 == 0
                return Math.floor((days[median] + days[median + 1]) / 2)
            else
                return days[median]
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
	])


#####################################################################
# Payments
#####################################################################

nameListCtrl = 'sales.paymentsListViewCtrl'
nameListEditCtrl = 'sales.paymentsListEditViewCtrl'

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
	])