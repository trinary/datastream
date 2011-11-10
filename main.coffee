express = require('express')
dataset = require './dataset'

app = express.createServer()
app.use express.bodyParser()
app.listen(3000)

thing_one = "one"

io = require 'socket.io'
iosocket = io.listen app
global_sockets = []

iosocket.sockets.on 'connection',(newsocket) ->
  console.log "got id #{newsocket.id}"
  global_sockets[newsocket.id] = newsocket
  global_sockets[newsocket.id].emit 'welcome', "Hi there."
  newsocket

iosocket.sockets.on 'disconnect', (oldsocket) ->
  console.log "lost id #{oldsocket.id}"
  delete global_sockets[oldsocket.id]


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
  console.log thing_one
  console.log global_sockets.size
  for sock in global_sockets
    console.log "sending #{req.body} to id #{sock.id}"
    sock.emit 'data', req.body
  console.log "w...what?"
  ds.insert req.body, req.params.name
  res.send
    status: 201,
    message: "added",
    href: "http://localhost:3000/sets/#{req.params.name}/data"

app.get '/', (req,res) ->
  res.sendfile __dirname + '/index.html'




