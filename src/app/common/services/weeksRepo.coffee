###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.weeksRepo'

class WeeksRepo

	constructor: (@$log, @env, @_, @filterDate) ->
        @weeks = []
        @_changes = 0

    create: () ->
        week: @filterDate(new Date(), 'yyyy-MM-dd')
        charges: {}
    
    getAll: () ->
        return @weeks
    
    countAll: () ->
        return @weeks.length

    add: (week) ->
        @weeks.push(week)
        @_changes++
        
    changes: () ->
        return @_changes
        
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
        
    removeAtIndex: (index) ->
        @weeks.splice(index, 1)
        return @

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', '$filter', ($log, env, underscore, $filter) ->
	new WeeksRepo($log, env, underscore, $filter('date'))
])