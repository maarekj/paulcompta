express = require('express')
app = express()
server = require('http').createServer(app)

app.use express.bodyParser()

app.post '/save', (req, res) ->
    token = req.query.token
    utils = require('./utils').create(token)

    utils.sendContentInSharedFile(req.body)
    .then (response) ->
        res.json(response.response.statusCode, response.body)
    .fail (error) ->
        console.log error
        res.json(error.response?.statusCode ? 500, error.body ? error)
        
app.get '/load', (req, res) ->
    token = req.query.token
    utils = require('./utils').create(token)
    
    utils.loadContentOfSharedFile()
    .then (response) ->
        res.json(response.response.statusCode, response.body)
    .fail (error) ->
        console.log error
        res.json(error.response?.statusCode ? 500, error.body ? error)

try
    if process.env.APP_LIVE_RELOAD == "on" 
        app.use(require('grunt-contrib-livereload/lib/utils').livereloadSnippet)
catch ex
    console.log ex

exports = module.exports = server
exports.express = express

exports.use = () ->
    app.use.apply(app, arguments)
