request = require('request')
Q = require('q')

extend = (object, properties) ->
    for key, val of properties
        object[key] = val
    return object

qrequest = (options) ->
    deferred = Q.defer()
    request options, (error, response, body) ->
        try
            body = JSON.parse(body)
        if error
            deferred.reject new Error(error)
        else
            deferred.resolve
                response: response
                body: body

    return deferred.promise

qrequest.get = (url, options) ->
    defaults =
        url: url
        method: 'GET'
    options = extend defaults, options

    return qrequest options

qrequest.post = (url, options) ->
    defaults =
        url: url
        method: 'POST'
    options = extend defaults, options

    return qrequest options
    
qrequest.put = (url, options) ->
    defaults =
        url: url
        method: 'put'
    options = extend defaults, options

    return qrequest options
    
qrequest.delete = (url, options) ->
    defaults =
        url: url
        method: 'delete'
    options = extend defaults, options

    return qrequest options

module.exports = qrequest
        