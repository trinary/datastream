window.data = []
socket = io.connect 'http://localhost:3000'
console.log "ok here we go"
socket.on 'welcome',(data) ->
  console.log(data)
socket.on 'data', (data) ->
  console.log data
  $('#data ol').append ->
    i = $('<li></li>').attr "set", data.set
    i.text data.data.value
    i
socket.on 'collection', (data) ->
  socket.emit 'subscribe', {name: data.name}
