myStepDefinitionsWrapper = ->
  @World = require("../support/world.coffee").World

  @Given /^I am on the Top page$/, (callback) ->
    @browser.visit "http://localhost:5000/", callback


  @When /^I fill each fields and press enter$/, (callback) ->
    @browser.fill("input[name='from']", "01:00")
    @browser.fill("input[name='to']", "02:30")
    @browser.fill("input[name='task']", "hoge")
    @browser.keypress("form input", 13)
    @browser.wait(callback)

  @Then /^the task should be registered$/, (callback) ->
    @assert.equal @browser.text("div.item span.from_to"), "01:00 - 02:30" 
    @assert.equal @browser.text("div.item span.time"), "(1.5)" 
    @assert.equal @browser.text("div.item span.task"), "hoge" 
    @browser.wait(callback)

module.exports = myStepDefinitionsWrapper