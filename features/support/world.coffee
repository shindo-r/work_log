zombie = require("zombie")
assert = require("assert");

zombie.Browser::keypress = (targetSelector, keyCode) ->
  event = @window.document.createEvent("HTMLEvents")
  event.initEvent "keypress", true, true
  event.keyCode = keyCode
  target = @window.document.querySelector(targetSelector)
  target and target.dispatchEvent(event)


exports.World = (callback) ->
  @browser = new zombie.Browser()
  @assert = assert
  callback()

