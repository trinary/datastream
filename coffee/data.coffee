window.data = []
window.socket = io.connect 'http://localhost:3000'
window.socket.on 'welcome',(data) ->
  console.log(data)
window.socket.on 'data', (data) ->
  console.log "data recieved", data
  if ! window.data[data.set]?
    window.data[data.set] = []
  window.data[data.set].push {time: data.data.timestamp, value: data.data.value}
  if window.data[data.set].length > 15
    window.data[data.set] = window.data[data.set].slice(-15)

window.socket.on 'collection', (data) ->
