/*
  TeamPlayer -- 2014

  This file holds the model for all tasks the user is part of.

  It's main functionality is to get, create, and edit tasks.
*/

//Define a task object as an event with additional fields:
//  --members: the members associated with this task
//  --done: whether this task has been completed
var Task = function(id, groupID, title, description, creatorID, dateCreated, dateDue, members) {
  this.event = new Event(id, groupID, title, description, creatorID, dateCreated, dateDue);
  this.members = members;
  this.done = false;
};

angular.module("myapp").factory('TaskModel', function() {
  var TaskModel = {};
  TaskModel.tasks = {};   //ID to task
  TaskModel.fetchedTasks = false;

  // get Tasks from server to Task model.
  TaskModel.getTasksFromServer = function(callback) {
    $.get("/get_task") // <-- url can be changed!
    .success(function(data, status) { // on success, there will be message to console
      console.log("task get Success: " , data);
      // update task
      for (var i in data){
        updateTask(data[i]);
      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task get error error: ",error);
      callback(error);
    });
  };

  // TaskModel.fetchTasksFromServer = function(callback) {
  //   // We really only need to ask the server for all tasks
  //   // the first time, so return if we already have.
  //   if(TaskModel.fetchedTasks) {
  //     return;
  //   }

  //   // Return the date object as a string in the form
  //   // mm/dd/yyyy. It pads days and months with 0's
  //   // to ensure that they are 2 chars.
  //   function mmddyyyy(date) {
  //     var year = date.getFullYear();

  //     //JS months are 0 based.
  //     //Also pad it to be MM if it is month 1-9
  //     var month = (1 + date.getMonth()).toString();
  //     month = month.length > 1 ? month : '0' + month;

  //     //Pad it to be DD if it is day 1-9 of the month
  //     var day = date.getDate().toString();
  //     day = day.length > 1 ? day : '0' + day;
  //     return month + "/" + day + "/" + year;
  //   }

  //   var startDate = new Date();
  //   startDate.setMonth(startDate.getMonth() - 1);

  //   var endDate = new Date();
  //   endDate.setMonth(endDate.getMonth() + 1);

  //   // Not changing info, so this is a get request
  //   $.get("/view_tasks",
  //   {
  //     "task[startDate]": mmddyyyy(startDate),
  //     "task[endDate]": mmddyyyy(endDate)
  //   })
  //   .success(function(data, status) {
  //     for(var i = 0; i < data.length; i++) {
  //       TaskModel.updateTask(data[i]);
  //     }
  //     callback();
  //     TaskModel.fetchedTasks = true;
  //   })
  //   .fail(function(xhr, textStatus, error) {
  //     callback(JSON.parse(xhr.responseText));
  //   });
  // }

  // update a task into the TaskModel.tasks map
  function updateTask(task){
    TaskModel.tasks[task.details.id] = new Task(task.details.id, task.details.group_id, 
      task.details.title, task.details.description, task.details.user_id, task.details.created_at, 
      task.details.due_date, task.members);
  }

  //Create and return a task with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  TaskModel.createTask = function(groupID, name, description, dateDue, members, callback) {
    $.post("/create_task", // <<----- url can be changed.
    {
      "task[group_id]": groupID,
      "task[title]": name,
      "task[description]": description,
      "task[due_date]": dateDue,
      "task[members]": members,
      "task[finished]": false
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task create Success: " , data);
      updateTask(data);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task create error: ",error);
      callback(error);
    });
  };

  // Create a task that might be cycling or repeating
  TaskModel.createTaskSpecial = function(groupID, name, description, dateDue, members, cycle, repostArray, callback) {
     $.post("/create_task_special", // <<----- url can be changed.
    {
      "task[group_id]": groupID,
      "task[title]": name,
      "task[description]": description,
      // "task[due_date]": dateDue,   // <-- repeating tasks should know when to stop repeating as well
      "task[members]": members,
      "task[cycle]": cycle,
      "task[repeat_days]": repostArray,
      "task[finished]": false
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task special create Success: " , data);
      updateTask(data.task);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task special create error: ",error);
      callback(error);
    });
  };

  //Update a task with all of the fields. If a field is null, it is not updated
  TaskModel.editTask = function(taskID, title, description, dateDue, cycle, repeatArray, members) {
    //TODO
  };

  //Set the given task as finished, and update to the database
  TaskModel.setFinished = function(taskID) {
    //TODO
  };

  //Return all tasks for this user as a list of Task objects
  // TaskModel.getTasks = function() {
  //   var taskArray = [];
  //   for(task in TaskModel.tasks) {
  //     taskArray.push(TaskModel.tasks[task]);
  //   }

  //   return taskArray;
  // };

  return TaskModel;
});
