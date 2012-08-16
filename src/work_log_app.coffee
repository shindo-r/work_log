class WorkLogApp extends Spine.Controller

  constructor: ->
    super

    @date_navigator = new DateNavigator(el: "#date_navigator")
    @work_log_item_list = new WorkLogItemList(el: "#work_log_item_list") 
    @total_view = new TotalView(el: "#total_view")

    @date_navigator.bind "update",  (selected_date) => @work_log_item_list.refresh_by(selected_date) 
    @date_navigator.bind "update",  (selected_date) => @total_view.refresh_by(selected_date) 

    @date_navigator.render()
    @total_view.refresh()


$ -> new WorkLogApp(el: "#views") 
