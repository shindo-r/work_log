// Generated by CoffeeScript 1.3.3
var WorkLogApp,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

WorkLogApp = (function(_super) {

  __extends(WorkLogApp, _super);

  function WorkLogApp() {
    var _this = this;
    WorkLogApp.__super__.constructor.apply(this, arguments);
    this.date_navigator = new DateNavigator({
      el: "#date_navigator"
    });
    this.work_log_item_list = new WorkLogItemList({
      el: "#work_log_item_list"
    });
    this.total_view = new TotalView({
      el: "#total_view"
    });
    this.date_navigator.bind("update", function(selected_date) {
      return _this.work_log_item_list.refresh_by(selected_date);
    });
    this.date_navigator.bind("update", function(selected_date) {
      return _this.total_view.refresh_by(selected_date);
    });
    this.date_navigator.render();
    this.total_view.refresh();
  }

  return WorkLogApp;

})(Spine.Controller);

$(function() {
  return new WorkLogApp({
    el: "#views"
  });
});
