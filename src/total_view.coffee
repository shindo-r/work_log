STORE_FORMAT = "YYYY/MM/DD Z"
class TotalView extends Spine.Controller

  target_date: moment().local().sod()
  
  elements:
    ".items":     "items" 
 
  constructor: ->
    super
    WorkLog.bind("save",  @refresh)

  refresh: (target_date)->
    @target_date = target_date if target_date

    total_time_of_each_task = {}
    total_time_of_all_task = 0
    for work_log in WorkLog.by_date(@target_date.format(STORE_FORMAT))
      total_time_of_each_task[work_log.task] = 0 unless total_time_of_each_task[work_log.task]
      total_time_of_each_task[work_log.task] += work_log.time
      total_time_of_all_task += work_log.time

    @items.empty()
    @items.append("<li>#{task} : #{total_time}</li>") for task, total_time of total_time_of_each_task
    @items.append("<li>total : #{total_time_of_all_task}</li>")


  remove: =>
    @instance.destroy()

$ -> new TotalView(el: "#total_view").refresh()


