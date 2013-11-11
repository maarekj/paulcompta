###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.weeksRepo'

class WeeksRepo

	constructor: (@$log, @env, @_, @filterDate, @moment) ->
        @weeks = []

    create: () ->
        monday = @moment().days(1)
        week: @filterDate(monday.toDate(), 'yyyy-MM-dd')
        charges: {}
        sales: [0, 0, 0, 0, 0, 0, 0]
        modalities:
            cheque: 0
            cash: 0
            ticket: 0        
    
    getAll: () ->
        return @weeks
    
    countAll: () ->
        return @weeks.length

    add: (week) ->
        @weeks.push(week)
        
    count: () ->
        return @weeks.length
        
    save: (index, week) ->
        @weeks[index] = week
        
    get: (index) ->
        return @getAll()[index]
        
    getChargesItems: () ->
        items = []
        for week in @getAll()
            for charge of week.charges
                items.push charge

        return @_.uniq items
        
    getTotalForCharge: (c) ->
        cc = []
        for week in @weeks
            cc.push(week.charges[c])
        add = (memo, num) ->
            if num?
                return memo + num
            else
                return memo
        return @_.reduce cc, add, 0
        
    getTotalOfCharge: (week) ->
        total = 0
        for charge, price of week.charges
            total += price
        return total

    getTotalAllCharge: () ->
        weeks = @getAll()
        totals = (@getTotalOfCharge(week) for week in weeks)
        return @_.reduce totals, ((memo, num) -> memo + num), 0

    getTotalSales: (week) ->
        total = 0
        for day, sale of week.sales
            total += sale
        return total

    getStats: () ->
        weeks = @getAll()
        stats = []
        for week in weeks
            totalCharges = @getTotalOfCharge week
            totalSales = @getTotalSales week
            stats.push
                week: week.week
                totalCharges: totalCharges
                totalSales: totalSales
                profits: totalSales - totalCharges

        total = @_.reduce stats, (memo, week) ->
            memo.totalCharges = memo.totalCharges + week.totalCharges
            memo.totalSales = memo.totalSales + week.totalSales
            memo.profits = memo.profits + week.profits
            memo
        , {totalCharges: 0, totalSales: 0, profits: 0}

        stats.push
            week: "Total"
            totalCharges: total.totalCharges
            totalSales: total.totalSales
            profits: total.profits

        return stats
        
    removeAtIndex: (index) ->
        @weeks.splice(index, 1)
        return @        

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', '$filter', "moment", ($log, env, underscore, $filter, moment) ->
	new WeeksRepo($log, env, underscore, $filter('date'), moment)
])