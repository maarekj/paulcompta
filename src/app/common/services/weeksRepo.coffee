###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.weeksRepo'

class WeeksRepo

	constructor: (@$log, @env, @_, @gdrive) ->
        @weeks = [
            {
                "week": new Date("2013-02-25")
                "charges":
                    "Employé": 40
                    "Aliments": 366.80
                    "Essence": 34.82
            }
            {
                "week": new Date("2013-03-04")
                "charges":
                    "Employé": 105
                    "Aliments": 515.07
                    "Bois": 39.70
                    "Essence": 68.92
                    "Autres": 61.40
            }
            {
                "week": new Date("2013-03-11")
                "charges":
                    "Loyer": 450
                    "Employé": 50
                    "Aliments": 384.58
                    "Bois": 133
                    "Essence": 35.78
                    "Autres": 64.57
            }
        ]
        
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

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', 'common.services.gdriveService', ($log, env, underscore, gdrive) ->
	new WeeksRepo($log, env, underscore, gdrive)
])