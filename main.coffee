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
  ds = new dataset.Dataset
  list = []
  ds.eachCollection (coll) =>
    if coll.options? && coll.options.create?
      newsocket.emit 'collection', coll
  newsocket.emit 'welcome', "Hello."

iosocket.sockets.on 'disconnect', (oldsocket) =>
  id = "#{oldsocket.id}"
  console.log "Disconnecting #{id}"
  delete global_sockets[id]

iosocket.sockets.on 'list', (socket) =>
  console.log "client #{socket.id} is asking for sets"


app.get '/sets/:name', (req,res) ->
  ds = new dataset.Dataset
  res.send {name: req.params.name}, 200

app.post '/sets', (req,res) ->
  ds = new dataset.Dataset
  ds.new req.body.set.name
  loc = "http://localhost:3000/sets/#{req.body.set.name}"
  res.header "Location", loc
  res.send {status: 201, message: "created", href: loc},201

app.post '/sets/:name/data', (req, res) =>
  obj = { set: req.params.name, data: {} }
  obj.data.value = req.body.value
  console.log "v: #{req.body.value}, t: #{req.body.timestamp}"
  obj.data.timestamp = new Date(req.body.timestamp)
  obj.data.attributes = req.body.attributes if req.body.attributes?

  ds = new dataset.Dataset
  for id, sock of global_sockets
    sock.emit 'data', obj
  ds.insert obj, req.params.name
  res.send
    status: 201,
    message: "added",
    href: "http://localhost:3000/sets/#{req.params.name}/data"

app.get '/', (req,res) ->
  res.sendfile __dirname + '/static/index.html'
