mongo = require 'mongodb'
Db = require('mongodb').Db
Server = require('mongodb').Server




class exports.Dataset
  constructor: (@name) ->
    host = 'localhost'
    port = 27017
    server = new Server host, port, {}
    @mongo = new Db 'dataproj', server
    @mongo.open (err,db) ->
      db.createCollection(@name, (err, coll) =>
        console.log "created #{coll}"
        @coll = coll
      )
  insert: (obj) ->
    console.log @mongo
    @mongo.open (err, db) ->
      db.collection @name, (err, coll) ->
        coll.insert(obj)
