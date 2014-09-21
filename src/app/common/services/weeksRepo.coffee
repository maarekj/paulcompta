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

    getYears: () ->
        @_.chain(@getAll()).groupBy((week) ->
            return new Date(week.week).getFullYear()
        ).keys().value()

    # La fonction filtre les "weeks" en fonction de "year".
    # Si year = null, il n'y a aucun filtre
    #
    filterByYear: (weeks, year) ->
        if year == null
            return weeks
        year = parseInt(year)
        @_(weeks).filter (week) ->
            date = new Date(week.week)
            return date.getFullYear() == year

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

    getTotalForChargeByYear: (c, year) ->
        weeks = @filterByYear(@weeks, year)

        cc = []
        for week in weeks
            cc.push(week.charges[c])

        add = (memo, num) ->
            return memo + num if num?
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

    getTotalAllChargeByYear: (year) ->
        weeks = @filterByYear(@weeks, year)
        totals = (@getTotalOfCharge(week) for week in weeks)
        return @_.reduce totals, ((memo, num) -> memo + num), 0

    getTotalSales: (week) ->
        total = 0
        for day, sale of week.sales
            total += sale
        return total

    getStatsByYear: (year) ->
        weeks = @filterByYear(@getAll(), year)
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

angular.module(name, []).factory(name,
    ['$log', 'common.services.env', 'underscore', '$filter', "moment", ($log, env, underscore, $filter, moment) ->
        new WeeksRepo($log, env, underscore, $filter('date'), moment)
    ])