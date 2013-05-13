request = require('request')
qrequest = require('./qrequest')
Q = require('q')

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

    getChildren: (fileId) ->
        url = "#{@baseUrl}/files/#{fileId}/children?access_token=#{@token}"

        qrequest.get url

    getFile: (fileId) ->
        url = "#{@baseUrl}/files/#{fileId}?access_token=#{@token}"
        qrequest.get url

    getSharedFile: () ->        
        @getChildren('appdata')
        .then (response) =>
            if response.body?.items?.length > 0
                return @getFile(response.body.items[0].id)
            else
                return @createNewFileInAppdata()

    getSharedFileId: () ->
        @getSharedFile().get('body').get('id')
    
    createNewFileInAppdata: () ->
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

        qrequest options

    deleteFileId: (fileId) ->
        url = "#{@baseUrl}/files/#{fileId}?access_token=#{@token}"
        qrequest.del url
    
    cleanAppdata: () ->
        deferred = Q.defer()

        # On récupère la liste des fichier à supprimer
        @getChildren('appdata')
        .then (response) =>
            # On parcour les fichiers à supprimer
            numberItems = response.body.items.length
            i = 0
            
            # Si pas de fichier à supprimer on résous la promise tout de suite
            @getFile('appdata').then deferred.resolve, deferred.reject, deferred.notify if numberItems == 0

            for file in response.body.items
                # On supprime le fichier
                @deleteFileId(file.id)
                .then (response) =>
                    # On informe de l'avancement
                    deferred.notify
                        index: ++i
                        total: numberItems
                        file: response.body
                    # Si tout les fichier on été supprimer on résous la promise
                    if i == numberItems
                        @getFile('appdata').then deferred.resolve, deferred.reject, deferred.notify

        return deferred.promise
        
    sendContentForFileId: (fileId, content) ->
        url = "#{@baseUploadUrl}/files/#{fileId}?access_token=#{@token}"
        options =
            url: url
            method: "PUT"
            "content-type": "application/paul-compta"
            body: JSON.stringify(content)
        qrequest(options)

    sendContentInSharedFile: (content) ->
        @getSharedFileId()
        .then (fileId) =>
            @sendContentForFileId fileId, content

module.exports.create = (token) ->
    return new Utils(token)