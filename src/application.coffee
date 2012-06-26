$ = jQuery

class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "hour"
  @extend Spine.Model.Local


class Item extends Spine.Controller
  render: =>
    @replace($("#itemTemplate").tmpl(@instance))
  

class TaskApp extends Spine.Controller
  events:
    "keypress input[name='task']":   "create"
    "keypress input[name='hour']":   "create"

  elements:
    ".items":     "items" #こうしておくと@itemsで参照可
    "form input[name='task']": "entry_task"
    "form input[name='hour']": "entry_hour"

  constructor: ->
    super
    WorkLog.bind("create",  @addOne) #Task.createが実行された時に、addOneを呼ぶ。
    WorkLog.fetch() #何の意味が有る？
  
  addOne: (work_log) =>
    view = new Item(instance: work_log)
    @items.append(view.render()) #appendはJQueryのメソッド
  
  addAll: =>
    WorkLog.each(@addOne)

  create: (e) -> #eはjavascriptのイベントオブジェクト
    if (e.keyCode == 13)
      e.preventDefault() #submitをキャンセル？
      WorkLog.create( task:@entry_task.val(), hour:@entry_hour.val())
      @entry_task.val("")
      @entry_hour.val("")  

$ -> #JQueryの構文 ページのドムを構築後に、関数を実行する
  new TaskApp(el: "#work_logs") #elをしているする事でそこのDOMを操作できる(?)


