window.data = []
socket = io.connect 'http://localhost:3000'
socket.on 'welcome',(data) ->
  console.log(data)
socket.on 'data', (data) ->
  if ! window.data[data.set]?
    window.data[data.set] = []
  window.data[data.set].push {time: data.data.timestamp, value: data.data.value}
  if window.data[data.set].length > 15
    window.data[data.set] = window.data[data.set].slice(-15)
  #$('#data ol').append ->
    #    i = $('<li></li>').attr "set", data.set
    #i.text data.data.value
    #i

socket.on 'collection', (data) ->
  socket.emit 'subscribe', {name: data.name}
