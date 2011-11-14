mongo = require 'mongodb'
Db = require('mongodb').Db
Server = require('mongodb').Server


class exports.Dataset
  constructor: ->
    host = 'localhost'
    port = 27017
    server = new Server host, port, {}
    @mongo = new Db 'dataproj', server

  new: (collname) ->
    @mongo.open (err, db) ->
      db.collection(collname, (err, coll) ->
        if err
          console.log err
      )

  insert: (obj, collname) ->
    @mongo.open (err,db) ->
      db.collection(collname, (err, coll) ->
        if err
          console.log err
          return
        coll.insert(obj)
      )
  eachCollection: (fn) ->
    console.log "listing"
    list = []
    @mongo.open (err,db) ->
      if err
        console.log err
        return
      console.log "collInfo"
      db.collectionsInfo (err, cursor) ->
        if err
          console.log err
          return
        cursor.toArray (err,items) ->
          items.forEach (item) ->
            fn item
