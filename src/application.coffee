$ = jQuery

class WorkLog extends Spine.Model
  @configure "WorkLog", "task", "hour"
  @extend Spine.Model.Local

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

  elements:
    ".items":     "items" #こうしておくと@itemsで参照可
    "form#entry_log": "form"

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
      WorkLog.fromForm(@form).save()
      clear(@form)

$ -> #JQueryの構文 ページのドムを構築後に、関数を実行する
  new WorkLogApp(el: "#work_logs") #elをしているする事でそこのDOMを操作できる(?)

# 以下、ユーティリティメソッド

clear = (form)->
  form.find('input').each -> 
    $(this).val('')
  $(form.find('input')[0]).focus()

press_enter_key = (event)->
  event.keyCode == 13

