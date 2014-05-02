// **NOTE: specs such as return values are not set in stone.

var Task = new Event();
Task.done = false;
Task.members = [];

angular.module("myapp").factory('TaskModel', function() {
  var TaskModel = {};
  TaskModel.tasks = {};   //ID to task

  //Create and return a task with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  TaskModel.createTask = function(groupID, title, description, dateCreated, dateDue, cycle, repostArray, members) { // creator ID
    //TODO
  };

  //Update a task with all of the fields. If a field is null, it is not updated
  TaskModel.editTask = function(taskID, title, description, dateDue, cycle, repostArray, members) {
    //TODO
  };

  //Set the given task as finished, and update to the database
  TaskModel.setFinished = function(taskID) {
    //TODO
  }

  //Return all tasks for this user as a list of Task objects
  TaskModel.getTasks = function() {
    var dummyTask = new Task();
    dummyTask.id = 0;
    dummyTask.groupID = 0;
    dummyTask.title = "Dummy Task";
    dummyTask.description = "Finish these method stubs!"
    dummyTask.creator = 0;
    dummyTask.dateCreated = new Date();
    dummyTask.dateDue = new Date();
    dummyTask.cycle = false;
    dummyTask.repost = [false, false, false, false, false, false, false];
    dummyTask.done = false;
    dummyTask.members = [0];

    var fakeTask = new Task();
    fakeTask.id = 1;
    fakeTask.groupID = 0;
    fakeTask.title = "Fake Task";
    fakeTask.description = "Finish the writeup!"
    fakeTask.creator = 0;
    fakeTask.dateCreated = new Date();
    fakeTask.dateDue = new Date("5/23/2014");
    fakeTask.cycle = false;
    fakeTask.repost = [false, false, false, false, false, false, false];
    fakeTask.done = false;
    fakeTask.members = [0];

    return [dummyTask, fakeTask];
  }

  return TaskModel;
});
