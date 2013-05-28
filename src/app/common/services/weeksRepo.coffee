###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.weeksRepo'

class WeeksRepo

	constructor: (@$log, @env, @_) ->
        @weeks = []
        
    create: () ->
        week: new Date()
        charges: {}
    
    getAll: () ->
        return @weeks
    
    add: (week) ->
        @weeks.push(week)
        
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

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', ($log, env, underscore) ->
	new WeeksRepo($log, env, underscore)
])