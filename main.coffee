
express = require('express')
app = express.createServer()
app.use express.bodyParser()
dataset = require './dataset'

app.get '/sets/:name', (req,res) ->
  ds = new dataset.Dataset req.params.name
  res.send {name: req.params.name}, 200

app.post '/sets', (req,res) ->
  ds = new dataset.Dataset req.body.set.name
  loc = "http://localhost:3000/sets/#{req.body.set.name}"
  res.header "Location", loc
  res.send {status: 201, message: "created", href: loc},201

app.post '/sets/:name/data', (req, res) ->
  ds = new dataset.Dataset req.params.name
  console.log "ok gonna INSERT"
  ds.insert req.body
  res.send
    status: 201,
    message: "added",
    href: "http://localhost:3000/sets/#{req.params.name}/data"
  201

app.listen(3000)

