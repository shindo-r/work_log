class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "hour", "date"
  @extend Spine.Model.Local

  @tasks: ->
    unique($.map(@all(), (work_log, i)-> work_log.task))

  @by_date: (date)->
    @findAllByAttribute("date", date)

  constructor: ->
    super
    @bind("beforeSave", @before_save)

  before_save: ->
    @hour = parseFloat(@hour)

  validate: ->
    @errors = []
    @errors.push("Task is required") unless @task
    @errors.push("Hour is required") unless @hour
    @errors.push("Hour should be number") if @hour and isNaN(@hour)
    !Spine.isBlank(@errors)

