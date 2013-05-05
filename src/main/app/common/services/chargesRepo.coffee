###
Example of a service shared across views.
Wrapper around the data layer for the app. 
###
name = 'common.services.chargesRepo'

class ChargesRepo

	constructor: (@$log, @env, @_) ->
        @charges = [
            {
                "week": new Date("2013-02-25")
                "outlays":
                    "Employé": 40
                    "Aliments": 366.80
                    "Essence": 34.82
            }
            {
                "week": new Date("2013-03-04")
                "outlays":
                    "Employé": 105
                    "Aliments": 515.07
                    "Bois": 39.70
                    "Essence": 68.92
                    "Autres": 61.40
            }
            {
                "week": new Date("2013-03-11")
                "outlays":
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
        outlays: {}
    
    getAll: () ->
        return @charges
    
    add: (charge) ->
        @charges.push(charge)
        
    save: (index, charge) ->
        @charges[index] = charge
        
    get: (index) ->
        return @getAll()[index]
        
    getOutlaysItems: () ->
        items = []
        for charge in @getAll()
            for outlay of charge.outlays
                items.push outlay

        return @_.uniq items
        
    getTotalOfCharge: (charge) ->
        total = 0
        for outlay, price of charge.outlays
            total += price
        return total
        
    removeAtIndex: (index) ->
        @charges.splice(index, 1)
        return @

angular.module(name, []).factory(name, ['$log', 'common.services.env', 'underscore', ($log, env, underscore) ->
	new ChargesRepo($log, env, underscore)
])