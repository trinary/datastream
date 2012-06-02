mongo = require 'mongodb'
util = require 'util'
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
      db.collection("datasets", (err, coll) ->
        if err
          console.log err
        coll.insert({name: collname, created_at: new Date })
      )

  insert: (obj, collname) ->
    @mongo.open (err,db) ->
      db.collection(collname, (err, coll) ->
        if err
          console.log err
          return
        coll.insert(obj)
      )
  list: (fn) ->
    @mongo.open (err,db) ->
      if err
        console.log err
      db.collection "datasets", (err, coll) ->
        if err
          console.log err
          return
        return coll.find().toArray (err,items) ->
          fn items

  eachCollection: (fn) ->
    @mongo.open (err,db) ->
      if err
        console.log err
      db.collection "datasets", (err, coll) ->
        if err
          console.log err
          return
        coll.find().toArray (err,items) ->
          items.forEach (item) ->
            fn item
