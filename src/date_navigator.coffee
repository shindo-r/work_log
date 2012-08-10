HAML_TEMP = '''
  %div.prev_date
    prev
  %div.selected_date
    = selected_date.format("MM/DD")
  %div.next_date
    next
  %div#calendar-container
'''

class DateNavigator extends Spine.Controller

  selected_date: moment().local().sod()

  events:
    'click .next_date': 'next_date'
    'click .prev_date': 'prev_date'

  render: ->
    view_template = Haml(HAML_TEMP)
    @html(view_template(selected_date:@selected_date))
    @calendar = @setup_calendar()
    @trigger('update')

  next_date: ->
    @selected_date.add('days', +1)
    @render()

  prev_date: ->
    @selected_date.add('days', -1)
    @render()

  select_calendar_date: (e)->
    @selected_date = moment(@calendar.selection.get().toString(), 'YYYYMMDD')
    @render()

  setup_calendar: ->
    Calendar.setup
      cont: "calendar-container"
      date: Number(@selected_date.format("YYYYMMDD"))
      bottomBar: true
      titleFormat: '%Y/%m'
      weekNumbers: false
      selection: Number(@selected_date.format("YYYYMMDD"))
      onSelect: =>
        @select_calendar_date()



$ -> new DateNavigator(el: "#date_navigator").render()


