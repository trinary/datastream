express = require('express')
dataset = require './dataset'

app = express.createServer()
app.use express.bodyParser()
app.listen(3000)

io = require 'socket.io'
global_sockets = []
socket = io.listen app

socket.sockets.on 'connection',(socket) ->
  console.log "got id #{socket.id}"
  global_sockets[socket.id] = socket

socket.sockets.on 'disconnect', (socket) ->
  console.log "lost id #{socket.id}"
  global_sockets[socket.id] = socket


app.get '/sets/:name', (req,res) ->
  ds = new dataset.Dataset req.params.name
  res.send {name: req.params.name}, 200


app.post '/sets', (req,res) ->
  ds = new dataset.Dataset
  ds.new req.body.set.name
  loc = "http://localhost:3000/sets/#{req.body.set.name}"
  res.header "Location", loc
  res.send {status: 201, message: "created", href: loc},201

app.post '/sets/:name/data', (req, res) ->
  ds = new dataset.Dataset
  console.log "ok gonna INSERT"
  console.log global_sockets
  for sock in global_sockets
    console.log "sending #{req.body} to id #{socket.id}"
    socket.emit 'data', req.body
  console.log "w...what?"
  ds.insert req.body, req.params.name
  res.send
    status: 201,
    message: "added",
    href: "http://localhost:3000/sets/#{req.params.name}/data"
  201
app.get '/', (req,res) ->
  res.sendfile __dirname + '/index.html'




