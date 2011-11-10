express = require 'express'
dataset = require './lib/dataset'
util = require 'util'

app = express.createServer()
app.use express.bodyParser()
app.listen(3000)


io = require 'socket.io'
iosocket = io.listen app
global_sockets = []

iosocket.sockets.on 'connection',(newsocket) =>
  id = "#{newsocket.id}"
  console.log "got id #{id}"
  global_sockets[id] = newsocket
  newsocket.emit 'welcome', "Hi there.  You are #{id}"

iosocket.sockets.on 'disconnect', (oldsocket) =>
  id = "#{oldsocket.id}"
  console.log "Disconnecting #{id}"
  delete global_sockets[id]

app.get '/sets/:name', (req,res) ->
  ds = new dataset.Dataset req.params.name
  res.send {name: req.params.name}, 200

app.post '/sets', (req,res) ->
  ds = new dataset.Dataset
  ds.new req.body.set.name
  loc = "http://localhost:3000/sets/#{req.body.set.name}"
  res.header "Location", loc
  res.send {status: 201, message: "created", href: loc},201

app.post '/sets/:name/data', (req, res) =>
  ds = new dataset.Dataset
  for id, sock of global_sockets
    sock.emit 'data',req.body
  ds.insert req.body, req.params.name
  res.send
    status: 201,
    message: "added",
    href: "http://localhost:3000/sets/#{req.params.name}/data"

app.get '/', (req,res) ->
  res.sendfile __dirname + '/static/index.html'




