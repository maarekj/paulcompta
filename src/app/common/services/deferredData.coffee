name = 'common.services.deferredData'

class DeferredData
    constructor: (isArray, @$q) ->
        if isArray
            @deferredData = []
        else
            @deferredData = {}
        @defer = @$q.defer()        
        @waiting = true
            
    $isWaiting: () ->
        @waiting
    
    $getPromise: () ->
        @defer.promise

    $isDeferredData: () ->
        true;

    $resolve: (data) ->
        if (@waiting)
            @waiting = false
            # We don't use directly angular.copy to copy into deferredData, since
            # for an array it removes all the added methods.
            if angular.isArray(@deferredData)
                # Copy the array items (deep copy)
                @deferredData.push(angular.copy(e)) for e in data
            else
                # Copy the object properties (deep copy)
                @deferredData[key] = angular.copy(e) for key, e of data
                for key in data
                    @deferredData[key] = angular.copy(data[key]);
        return @defer.resolve(@deferredData);
        
    $reject: (data) ->
        @defer.reject(data);
            
    $then: (callback) ->
        @defer.promise.then(callback);

angular.module(name, []).factory(name, ['$q', ($q) ->
    typeArray: () ->
        return new DeferredData(true, $q)
    typeObject: () ->
        return new DeferredData(false, $q)
    isDeferredData: (object) ->
        obj?.$isDeferredData?()
    then: (object, callback) ->
        if this.isDeferredData(object)
            object.$then(callback)
        else
            callback(object)            
])
