// Generated by CoffeeScript 1.3.3
var DateNavigator, HAML_TEMP,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HAML_TEMP = '%ul.date_list\n  %li.left\n    %a.prev_date{ href:"#" }\n      prev\n  %li.middle\n    = selected_date.format("MM/DD")\n  %li.right\n    %a.next_date{ href: "#" }\n      next\n%div#calendar-container';

DateNavigator = (function(_super) {

  __extends(DateNavigator, _super);

  function DateNavigator() {
    return DateNavigator.__super__.constructor.apply(this, arguments);
  }

  DateNavigator.prototype.selected_date = moment().local().sod();

  DateNavigator.prototype.events = {
    'click .next_date': 'next_date',
    'click .prev_date': 'prev_date'
  };

  DateNavigator.prototype.render = function() {
    var view_template;
    view_template = Haml(HAML_TEMP);
    this.html(view_template({
      selected_date: this.selected_date
    }));
    this.calendar = this.setup_calendar();
    return this.trigger('update', this.selected_date);
  };

  DateNavigator.prototype.next_date = function() {
    this.selected_date.add('days', +1);
    return this.render();
  };

  DateNavigator.prototype.prev_date = function() {
    this.selected_date.add('days', -1);
    return this.render();
  };

  DateNavigator.prototype.select_calendar_date = function(e) {
    this.selected_date = moment(this.calendar.selection.get().toString(), 'YYYYMMDD');
    return this.render();
  };

  DateNavigator.prototype.setup_calendar = function() {
    var _this = this;
    return Calendar.setup({
      cont: "calendar-container",
      date: Number(this.selected_date.format("YYYYMMDD")),
      bottomBar: true,
      titleFormat: '%Y/%m',
      weekNumbers: false,
      selection: Number(this.selected_date.format("YYYYMMDD")),
      onSelect: function() {
        return _this.select_calendar_date();
      }
    });
  };

  return DateNavigator;

})(Spine.Controller);
