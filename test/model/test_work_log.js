module("WorkLog", {
	setup: function() {
		work_log = new WorkLog({task:"task_name", hour:"1.0"})
	}
});

test("invalid when 'task' is blank", function(){
	work_log.task = ""
	equal(work_log.isValid(), false, "isValid() == false")
});

test("valid when 'task' is not blank", function(){
	work_log.task = "aaa"
	equal(work_log.isValid(), true, "isValid() == true")
});

test("invalid when 'hour' is blank", function(){
	work_log.hour = ""
	equal(work_log.isValid(), false, "isValid() == false")
});

test("invalid when 'hour' is not number", function(){
	work_log.hour = "aaaa"
	equal(work_log.isValid(), false, "isValid() == false")
});

test("valid when 'hour' is not blank and 'hour' is number", function(){
	work_log.hour = "1.0"
	equal(work_log.isValid(), true, "isValid() == true")
});
