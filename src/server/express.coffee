express = require('express')
app = express()
server = require('http').createServer(app)

app.use express.bodyParser()

app.post '/save', (req, res) ->
    token = req.query.token
    utils = require('./utils').create(token)

    data = {
        name: "Joseph Maarek"
        wife: "Vanessa Maarek"
        type: "Aime de tout son coeur <3 <3"
    }

    utils.sendContentInSharedFile(data)
    .then (response) ->
        res.json(response.response.statusCode, response.body)
    .fail (error) ->
        console.log error
        res.json(error.response?.statusCode ? 500, error.body ? error)

try
    app.use(require('grunt-contrib-livereload/lib/utils').livereloadSnippet)
catch ex
    console.log ex

exports = module.exports = server
exports.express = express

exports.use = () ->
    app.use.apply(app, arguments)
