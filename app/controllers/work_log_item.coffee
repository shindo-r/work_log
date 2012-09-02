Spine = require('spine')

class WorkLogItem extends Spine.Controller
  events:
    "click .destroy": "remove"
  
  constructor: ->
    super
    @instance.bind("destroy", @release)

  render: =>
    @replace($("#itemTemplate").tmpl(@instance))
  
  remove: =>
    @instance.destroy()

    
module.exports = WorkLogItem