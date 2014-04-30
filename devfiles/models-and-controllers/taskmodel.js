var Task = new Event();
Task.createTask = function() {
	//TODO
};
Task.editTask = function() {
	//TODO
};
Task.setFinished = function(id) {
	//TODO
}

angular.module("myapp").factory('TaskModel', function() {
  var TaskModel = new Task();
  TaskModel.id = 0;
  TaskModel.uname = "";
  TaskModel.fname = "";
  TaskModel.lname = "";

  TaskModel.login = function(uname, psswd) {
  	//TODO
  }

  return TaskModel;
});