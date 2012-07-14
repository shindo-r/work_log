TIME_MATCHER = "([0-9]{2}):([0-9]{2})"

class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "from", "to", "time", "date"
  @extend Spine.Model.Local

  @tasks: ->
    unique($.map(@all(), (work_log, i)-> work_log.task))

  @by_date: (date)->
    @findAllByAttribute("date", date)

  constructor: ->
    super
    @bind("beforeSave", @calc_time)

  validate: ->
    @errors = []
    @errors.push("Task is required") unless @task
    unless ( [@from, @to].every (time) -> time.match TIME_MATCHER )
      @errors.push("From and To should need a format like '14:30'") 
    !Spine.isBlank(@errors)

  calc_time: ->
    hour = @hour_of(@to) - @hour_of(@from)
    minute = @minute_of(@to) - @minute_of(@from)
    minute = 60 + minute if minute < 0
    @time = hour + (minute/60)

  hour_of: (time)-> time.match(TIME_MATCHER)[1]
  minute_of: (time)-> time.match(TIME_MATCHER)[2]

