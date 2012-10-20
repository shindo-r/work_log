require = window.require
moment = require('moment/moment')
$ = require('jqueryify') unless $
STORE_FORMAT = "YYYY/MM/DD Z"

describe 'WorkLog', ->
  WorkLog = require('models/work_log')
  work_log = null

  describe 'Rules of attributes', ->
    beforeEach ->
      work_log = new WorkLog(
        task:'task_name',
        date:moment("2012-09-26"),
        from:'13:00',
        to: '14:00'
      )
      expect(work_log.validate()).toEqual(false)

    describe 'task', ->
      it "is required'", ->
        work_log.task = ""
        expect(work_log.validate()).toEqual(true)
        expect(work_log.errors[0]).toEqual("'Task' is required")

    describe 'date', ->
      it "is required'", ->
        work_log.date = ""
        expect(work_log.validate()).toEqual(true)
        expect(work_log.errors[0]).toEqual("'Date' is required")

    describe 'from', ->
      it "is required'", ->
        work_log.from = ""
        expect(work_log.validate()).toEqual(true)
        expect(work_log.errors[0]).toEqual("'From' is required")

      it "should need a format like '14:30'", ->
        for value in ["aaaa", "1400", "14:", ":00", "aa:aa"]
          work_log.from = value
          expect(work_log.validate()).toEqual(true)
          expect(work_log.errors[0]).toEqual("'From' should need a format like '14:30'")

      it "should be smaller than 'To'", ->
        work_log.from = "13:59"
        expect(work_log.validate()).toEqual(false)
        for value in ["14:00", "14:01"]
          work_log.from = value
          expect(work_log.validate()).toEqual(true)
          expect(work_log.errors[0]).toEqual("'From' should be smaller than 'To'")

    describe 'to', ->
      it "is required'", ->
        work_log.to = ""
        expect(work_log.validate()).toEqual(true)
        expect(work_log.errors[0]).toEqual("'To' is required")

      it "should need a format like '14:30'", ->
        for value in ["aaaa", "1400", "14:", ":00", "aa:aa"]
          work_log.to = value
          expect(work_log.validate()).toEqual(true)
          expect(work_log.errors[0]).toEqual("'To' should need a format like '14:30'")

    describe 'time', ->
      it "should be calculated on a save", ->
        expect(work_log.time).not.toBeDefined();
        work_log.save()
        expect(work_log.time).not.toBeNull()
      
      it "should be the hour from 'From' to 'To'", ->
        test_patterns = [
          { from:'13:00', to:'14:00', time:1 },
          { from:'13:00', to:'16:00', time:3 },
          { from:'13:00', to:'15:30', time:2.5 },
          { from:'13:15', to:'14:00', time:0.75 }
        ]
        for pattern in test_patterns
          work_log.from = pattern['from']
          work_log.to = pattern['to']
          expect(work_log.validate()).toEqual(false)
          work_log.save()
          expect(work_log.time).toEqual(pattern['time'])
  

  describe 'Class methods', ->

    describe 'tasks', ->
      it "gains unique tasks", ->
        test_patterns = [
          { stored_tasks:['AAA', 'BBB', 'CCC'], gained_tasks:['AAA', 'BBB', 'CCC'] },
          { stored_tasks:['AAA', 'AAA', 'BBB'], gained_tasks:['AAA', 'BBB'] },
          { stored_tasks:['AAA', 'AAA', 'AAA'], gained_tasks:['AAA'] },
          { stored_tasks:['AAA', 'BBB', 'BBB', 'CCC', 'CCC'], gained_tasks:['AAA', 'BBB', 'CCC'] },
          { stored_tasks:[], gained_tasks:[]}
        ]
        for pattern in test_patterns
          WorkLog.destroyAll()
          for task_name in pattern['stored_tasks']
            WorkLog.create(task:task_name, date:moment("2012-09-26"), from:'13:00', to:'14:00')
          expect(WorkLog.tasks()).toEqual(pattern['gained_tasks'])
  
    describe 'by_date', ->
      it "select tasks that have the argument date as the date attribute", ->
        test_patterns = [
          { 
            stored_worklogs:[
              { task:'A', date:'2012-09-06' },
              { task:'B', date:'2012-09-05' },
              { task:'C', date:'2012-09-07' }
            ],
            argument_date:'2012-09-06',
            gained_worklog_tasks:['A']
          },{ 
            stored_worklogs:[
              { task:'A', date:'2012-09-06' },
              { task:'B', date:'2012-09-06' },
              { task:'C', date:'2012-09-07' }
            ],
            argument_date:'2012-09-06',
            gained_worklog_tasks:['A', 'B']
          },{ 
            stored_worklogs:[
              { task:'A', date:'2012-09-05' },
              { task:'B', date:'2012-09-07' },
              { task:'C', date:'2012-09-08' }
            ],
            argument_date:'2012-09-06',
            gained_worklog_tasks:[]
          }
        ]
        for pattern in test_patterns
          WorkLog.destroyAll()
          for store_value in pattern['stored_worklogs']
            date = moment(store_value['date']).format(STORE_FORMAT)
            WorkLog.create(task:store_value['task'], date:date, from:'13:00', to:'14:00')
          gained_workLogs = WorkLog.by_date(moment(pattern['argument_date']).format(STORE_FORMAT))
          gained_worklog_tasks = $.map(gained_workLogs, (work_log, i)-> work_log.task)
          expect(gained_worklog_tasks).toEqual(pattern['gained_worklog_tasks'])
          





