STORE_FORMAT = "YYYY/MM/DD Z"
class WorkLogItemList extends Spine.Controller

  target_date: moment().local().sod()

  events:
    "keypress form input":   "create"
    "focus form input[name='task']": "load_suggest"

  elements:
    ".items":     "items" 
    ".errors":    "error_messages"
    "form#entry_log": "form"
    "input[name='task']": "task_field"

  constructor: ->
    super
    WorkLog.bind("save",  @addOne)
    WorkLog.bind("refresh", @addAll)
    WorkLog.fetch()
  
  refresh_by: (target_date)->
    @target_date = target_date
    @items.empty()
    @addAll()
    
  addOne: (work_log) =>
    view = new Item(instance: work_log)
    @items.append(view.render())
  
  addAll: =>
    @addOne(work_log) for work_log in WorkLog.by_date(@target_date.format(STORE_FORMAT))

  create: (e) ->
    if press_enter_key(e)
      e.preventDefault() 
      @error_messages.empty()
      worklog = WorkLog.fromForm(@form)
      worklog.date = @target_date.clone().format(STORE_FORMAT)
      if worklog.save()
        clear(@form)
      else
        @error_messages.append("<li>#{error}</li>") for error in worklog.errors

  load_suggest: (e) ->
    @task_field.autocomplete({ source: WorkLog.tasks()})




