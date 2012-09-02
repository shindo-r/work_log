require('lib/setup')

Spine = require('spine')
DateNavigator = require('controllers/date_navigator')
WorkLogItemList = require('controllers/work_log_item_list')
TotalView = require('controllers/total_view')

class App extends Spine.Controller
  
  el: "#views"
  
  constructor: ->
    super
    @date_navigator = new DateNavigator(el: "#date_navigator")
    @work_log_item_list = new WorkLogItemList(el: "#work_log_item_list") 
    @total_view = new TotalView(el: "#total_view")

    @date_navigator.bind "update",  (selected_date) => @work_log_item_list.refresh_by(selected_date) 
    @date_navigator.bind "update",  (selected_date) => @total_view.refresh_by(selected_date) 

    @date_navigator.render()
    @total_view.refresh()


module.exports = App
    