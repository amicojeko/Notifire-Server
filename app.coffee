app    = require('express')()
server = require('http').createServer(app)
io     = require('socket.io').listen(server)

port   = ~~process.env.PORT || 5000;
server.listen port, ->
  console.log "Listening on #{port}"

status =
  deviceConnected: false

app.get '/status.json', (req, res) ->
  res.json status

io.sockets.on 'connection', (socket) ->
  status.deviceConnected = true
  console.log '[STATUS] device connected'

  socket.emit 'news', hello: 'world'
  socket.on 'my other event', (data) ->
    console.log(data);
  socket.on 'disconnect', ->
    status.deviceConnected = false
    console.log '[STATUS] device disconnected'