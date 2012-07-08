DISPLAY_FORMAT = "MM/DD"
STORE_FORMAT = "YYYY/MM/DD Z"

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
    "click a.change_date" : "change_date"

  elements:
    ".items":     "items" #こうしておくと@itemsで参照可
    ".errors":    "error_messages"
    "form#entry_log": "form"
    "input[name='task']": "task_field"
    "#displayed_date": "displayed_date"
    "#previews_date": "previews_date"
    "#next_date": "next_date"

  constructor: ->
    super
    @selected_date = moment().local().sod()
    @refresh_date_element_by(@selected_date)
    WorkLog.bind("save",  @addOne) #Task.createが実行された時に、addOneを呼ぶ。
    WorkLog.bind("refresh", @addAll) #refeshはfetchのタイミングで呼ばれる。詳しくはlocal.coffeeを見よ
    WorkLog.fetch() #データをローカルストレージからロードしている。詳しくはlocal.coffeeを見よ
  
  addOne: (work_log) =>
    view = new Item(instance: work_log)
    @items.append(view.render()) #appendはJQueryのメソッド
  
  addAll: =>
    @addOne(work_log) for work_log in WorkLog.by_date(@selected_date.format(STORE_FORMAT))

  create: (e) -> #eはjavascriptのイベントオブジェクト
    if press_enter_key(e)
      e.preventDefault() #submitをキャンセル
      @error_messages.empty()
      worklog = WorkLog.fromForm(@form)
      worklog.date = @selected_date.clone().format(STORE_FORMAT)
      if worklog.save()
        clear(@form)
      else
        @error_messages.append("<li>#{error}</li>") for error in worklog.errors

  load_suggest: (e) ->
    @task_field.autocomplete({ source: WorkLog.tasks()})

  change_date: (e) ->
    switch e.currentTarget
      when @previews_date[0] then @selected_date.add('days', -1)
      when @next_date[0] then @selected_date.add('days', 1)
    @refresh_date_element_by(@selected_date)
    @items.empty()
    @addAll()

  refresh_date_element_by: (date)->
    @displayed_date[0].innerText = date.format(DISPLAY_FORMAT)
    @previews_date[0].innerText = date.clone().add('days', -1).format(DISPLAY_FORMAT)
    @next_date[0].innerText = date.clone().add('days', 1).format(DISPLAY_FORMAT)


$ -> #JQueryの構文 ページのドムを構築後に、関数を実行する
  new WorkLogApp(el: "#work_logs") #elをしているする事でそこのDOMを操作できる(?)

# 以下、ユーティリティメソッド

clear = (form)->
  form.find('input').each -> 
    $(this).val('')
  $(form.find('input')[0]).focus()

press_enter_key = (event)->
  event.keyCode == 13
