require('lib/spine_ext')

Spine = require('spine')
Util = require('lib/util')

TIME_MATCHER = "([0-9]{2}):([0-9]{2})"

class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "from", "to", "time", "date"
  @extend Spine.Model.Local

  validations:
    "'Task' is required": -> not @task
    "'From' is required": -> not @from
    "'To' is required":   -> not @to
    "'From' should need a format like '14:30'" : -> not @from.match TIME_MATCHER if @from 
    "'To' should need a format like '14:30'" : -> not @to.match TIME_MATCHER if @to 
    "'From' should be smaller than 'To'": -> 
      @is_from_bigger_than_to() if @from and @to and @from.match(TIME_MATCHER) and @to.match(TIME_MATCHER)

  @tasks: ->
    Util.unique($.map(@all(), (work_log, i)-> work_log.task))

  @by_date: (date)->
    @findAllByAttribute("date", date)

  constructor: ->
    super
    @bind("beforeSave", @calc_time)


  calc_time: ->
    hour = @hour_of(@to) - @hour_of(@from)
    minute = @minute_of(@to) - @minute_of(@from)
    minute = 60 + minute if minute < 0
    @time = hour + (minute/60)

  hour_of: (time)-> time.match(TIME_MATCHER)[1]
  minute_of: (time)-> time.match(TIME_MATCHER)[2]
  is_from_bigger_than_to: ->
    ( @hour_of(@to) < @hour_of(@from) ) or 
      ( @hour_of(@to) == @hour_of(@from) and @minute_of(@to) <= @minute_of(@from) )


module.exports = WorkLog