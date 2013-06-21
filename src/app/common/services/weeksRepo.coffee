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
        
    getTotalOfCharge: (week) ->
        total = 0
        for charge, price of week.charges
            total += price
        return total

    getTotalAllCharge: () ->
        weeks = @getAll()
        totals = (@getTotalOfCharge(week) for week in weeks)
        return @_.reduce totals, ((memo, num) -> memo + num), 0
        
    removeAtIndex: (index) ->
        @weeks.splice(index, 1)
        return @

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', '$filter', "moment", ($log, env, underscore, $filter, moment) ->
	new WeeksRepo($log, env, underscore, $filter('date'), moment)
])