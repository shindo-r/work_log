class Item extends Spine.Controller
  events:
    "click .destroy": "remove"
  
  constructor: ->
    super
    @instance.bind("destroy", @release)

  render: =>
    @replace($("#itemTemplate").tmpl(@instance))
  
  remove: =>
    @instance.destroy()



