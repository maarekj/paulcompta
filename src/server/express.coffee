express = require('express')
app = express()
server = require('http').createServer(app)

request = require('request')
qrequest = require('./qrequest')

app.use express.bodyParser()

baseUrl = "https://www.googleapis.com/drive/v2"
baseUploadUrl = "https://www.googleapis.com/upload/drive/v2"

app.get '/test', (req, res) ->
    qrequest.get("http://www.google.com").then (response) ->
        res.json(response.body)
    
    
app.get '/google/files/:fileId', (req, res) ->
    fileId = req.params.fileId
    token = req.query.token

    url = "#{baseUrl}/files/#{fileId}?access_token=#{token}"

    request url, (error, response, body) ->
        res.json(response.statusCode, JSON.parse(body))

app.get '/google/files/:fileId/children', (req, res) ->
    fileId = req.params.fileId
    token = req.query.token
    
    url = "#{baseUrl}/files/#{fileId}/children?access_token=#{token}"

    request url, (error, response, body) ->
        res.json(response.statusCode, JSON.parse(body))
        
app.delete '/google/files/:fileId/children', (req, res) ->
    token = req.query.token
    
    deleteFile = (fileId, callback) ->
        url = "#{baseUrl}/files/#{fileId}?access_token=#{token}"
        request.del url, callback
        
    fileId = req.params.fileId
    url = "#{baseUrl}/files/#{fileId}/children?access_token=#{token}"

    # On récupère la liste des fichiers qu'on va supprimer 1 à 1
    request url, (error, response, body) ->
        body = JSON.parse(body)
        for file in body.items
            deleteFile file.id, (error, response, body) ->
        res.json(response.statusCode, body)

app.post '/save', (req, res) ->
    token = req.query.token
    utils = require('./utils').create(token)

    data = {
        name: "Joseph Maarek"
        wife: "Vanessa Maarek"
        type: "Aime de tout son coeur <3 <3"
    }

    utils.sendContentInSharedFile data, (error, response, body) ->
        res.json(response.statusCode, body)

try
    app.use(require('grunt-contrib-livereload/lib/utils').livereloadSnippet)
catch ex
    console.log ex

exports = module.exports = server
exports.express = express

exports.use = () ->
    app.use.apply(app, arguments)
