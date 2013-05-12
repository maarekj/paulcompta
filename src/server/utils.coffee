request = require('request')

class Utils
    constructor: (@token) ->
        @baseUrl = "https://www.googleapis.com/drive/v2"
        @baseUploadUrl = "https://www.googleapis.com/upload/drive/v2"
    
    _parseBody: (body) ->
        try
            body = JSON.parse body
        catch e
            body = body
        return body

    getSharedFileId: (callback) ->    
        url = "#{@baseUrl}/files/appdata/children?access_token=#{@token}"
        request url, (error, response, body) =>
            body = @_parseBody body
            if body?.items?.length > 0
                callback(body.items[0]?.id)
            else
                @createNewFileInAppdata (error, response, body) ->
                    callback body?.id

    createNewFileInAppdata: (callback) ->
        url = "#{@baseUrl}/files?access_token=#{@token}"
        options =
            url: url
            method: "POST"
            json:
                mimeType: "application/paul-compta"
                title: "Paul Compta"
                parents: [
                    id: "appdata"
                ]

        request options, (error, response, body) =>
            callback error, response, @_parseBody body
    
    sendContentForFileId: (fileId, content, callback) ->
        url = "#{@baseUploadUrl}/files/#{fileId}?access_token=#{@token}"
        options =
            url: url
            method: "PUT"
            "content-type": "application/paul-compta"
            body: JSON.stringify(content)

        request options, (error, response, body) =>
            callback error, response, @_parseBody body

    sendContentInSharedFile: (content, callback) ->
        @getSharedFileId (fileId) =>
            @sendContentForFileId fileId, content, (error, response, body) =>
                callback error, response, @_parseBody body

module.exports.create = (token) ->
    return new Utils(token)