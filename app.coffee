express = require("express")

port = process.env.PORT || 5000
app = module.exports = express.createServer()

app.configure ->
  app.set "views", __dirname
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + "/")
  app.use app.router
  
app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()
  
app.get '/', (req, res)->
  res.redirect './index.html'

app.listen port, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

