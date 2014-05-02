/*
  TeamPlayer -- 2014

  This file holds the model for all tasks the user is part of.

  It's main functionality is to get, create, and edit tasks.
*/

//Define a task object as an event with additional fields:
//  --members: the members associated with this task
//  --done: whether this task has been completed
var Task = function(id, creatorID, groupID, title, description, dateCreated, dateDue, cycle, repostArray, members) {
  this.event = new Event(id, creatorID, groupID, title, description, dateCreated, dateDue, cycle, repostArray);
  this.members = members;
  this.done = false;
};

angular.module("myapp").factory('TaskModel', function() {
  var TaskModel = {};
  TaskModel.tasks = {};   //ID to task

  //Create and return a task with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  TaskModel.createTask = function(groupID, title, description, dateCreated, dateDue, cycle, repostArray, members) {
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
    //TODO ajax

    //Dummy objects for now
    var sevenFalse = [false, false, false, false, false, false, false];
    var dummyTask = new Task(0, 0, 0, "Dummy Task", "Finish these method stubs", new Date(), new Date(), false, sevenFalse, [0]);
    var fakeTask = new Task(0, 0, 0, "Fake Task", "Finish the writeup", new Date(), new Date("5/23/2014"), false, sevenFalse, [0]);

    return [dummyTask, fakeTask];
  }

  return TaskModel;
});
