class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "hour"
  @extend Spine.Model.Local

  @tasks: ->
    unique($.map(@all(), (work_log, i)-> work_log.task))

  constructor: ->
    super
    @bind("beforeSave", @before_save)

  before_save: ->
    @hour = parseFloat(@hour)

  validate: ->
    @errors = []
    @errors.push("Task is required") unless @task
    @errors.push("Hour is required") unless @hour
    @errors.push("Hour should be float value") if @hour and !isFloat(@hour)
    !Spine.isBlank(@errors)


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


class WorkLogApp extends Spine.Controller
  events:
    "keypress form input":   "create"
    "focus form input[name='task']": "load_suggest"

  elements:
    ".items":     "items" #こうしておくと@itemsで参照可
    ".errors":    "error_messages"
    "form#entry_log": "form"
    "input[name='task']": "task_field"

  constructor: ->
    super
    WorkLog.bind("save",  @addOne) #Task.createが実行された時に、addOneを呼ぶ。
    WorkLog.bind("refresh", @addAll) #refeshはfetchのタイミングで呼ばれる。詳しくはlocal.coffeeを見よ
    WorkLog.fetch() #データをローカルストレージからロードしている。詳しくはlocal.coffeeを見よ
  
  addOne: (work_log) =>
    view = new Item(instance: work_log)
    @items.append(view.render()) #appendはJQueryのメソッド
  
  addAll: =>
    WorkLog.each(@addOne)

  create: (e) -> #eはjavascriptのイベントオブジェクト
    if press_enter_key(e)
      e.preventDefault() #submitをキャンセル
      @error_messages.empty()
      worklog = WorkLog.fromForm(@form)
      if worklog.save()
        clear(@form)
      else
        @error_messages.append("<li>#{error}</li>") for error in worklog.errors

  load_suggest: (e) ->
    @task_field.autocomplete({ source: WorkLog.tasks()})

$ -> #JQueryの構文 ページのドムを構築後に、関数を実行する
  new WorkLogApp(el: "#work_logs") #elをしているする事でそこのDOMを操作できる(?)

# 以下、ユーティリティメソッド

clear = (form)->
  form.find('input').each -> 
    $(this).val('')
  $(form.find('input')[0]).focus()

press_enter_key = (event)->
  event.keyCode == 13

isFloat = (val)-> parseFloat(val)

unique = (array) ->
  storage = {}
  uniqueArray = []
  i = undefined
  value = undefined
  i = 0
  while i < array.length
    value = array[i]
    unless value of storage
      storage[value] = true
      uniqueArray.push value
    i++
  uniqueArray
