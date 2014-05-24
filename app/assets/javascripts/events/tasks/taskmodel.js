/*
  TeamPlayer -- 2014

  This file holds the model for all tasks the user is part of.

  It's main functionality is to get, create, and edit tasks.
*/

//Define a task object as an event with additional fields:
//  --members: the members associated with this task
//  --done: whether this task has been completed
var Task = function(id, groupID, groupName, title, description, creatorID, dateCreated, dateDue, members, done) {
  this.id = id;
  this.group = groupID;
  this.title = title;
  this.description = description;
  this.creator = creatorID;
  this.dateCreated = dateCreated;
  this.dateDue = dateDue;
  this.members = members;
  this.groupName = groupName;
  this.done = done;
};

angular.module("myapp").factory('TaskModel', ['GroupModel','UserModel', function(GroupModel, UserModel) {
  var TaskModel = {};
  TaskModel.tasks = {};   //ID to task
  TaskModel.generators = {};
  TaskModel.fetchedTasks = false;

  // get Tasks from server to Task model.
  TaskModel.refresh = function(callback) {
    $.get("/get_task") // <-- url can be changed!
    .success(function(data, status) { // on success, there will be message to console
      console.log("task get Success: " , data);
      // update tasks
      TaskModel.tasks = {};
      for (var i in data){
        updateTask(data[i]);
      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task get error error: ",error);
      callback(error);
    });

     $.get("/get_generators") // <-- url can be changed!
    .success(function(data, status) { // on success, there will be message to console
      console.log("task gen get Success: " , data);
      // update task generator
      for (var i in data){
        updateGenerator(data[i]);
      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task gen get error error: ",error);
      callback(error);
    });

  };

  function updateGenerator(generator){
    TaskModel.generators[generator.details.current_task_id] = generator;
  }

  // get Tasks from server to Task model.
  TaskModel.getTaskGeneratorsFromServer = function(callback) {
    $.get("/get_generators") // <-- url can be changed!
    .success(function(data, status) { // on success, there will be message to console
      console.log("task gen get Success: " , data);
      // update task generator
      for (var i in data){
        updateGenerator(data[i]);
      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task gen get error error: ",error);
      callback(error);
    });
  };

  

  // TaskModel.getTasksArray = function(){
  //   var myTasks = [];
  //   var tasks = TaskModel.tasks;

  //   for(var i in tasks){
  //     // turn members in this task into a string to display
  //     function memsToString(){
  //       var str = "";
  //       var first = true;
  //       for(var j in tasks[i].members){
  //         if(first){
  //           str+= UserModel.users[j].username;
  //           first = false;
  //         } else {
  //           str+= ", "+UserModel.users[j].username;
  //         }
  //       }
  //       return str;
  //     }

  //     myTasks.push({
  //       taskID: tasks[i].event.id,
  //       taskName: tasks[i].event.title,
  //       taskDesc: tasks[i].event.description,
  //       dueDate: tasks[i].event.dateDue,
  //       groupName: GroupModel.groups[tasks[i].event.group].name,
  //       members: memsToString(),
  //       creator: tasks[i].event.creator,
  //       done: tasks[i].done
  //     });
  //   }
  //   console.log("built tasks: ",myTasks);
  //   return myTasks;
  // }

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
    var members = {};
    for (var id in task.members){
      members[id] = UserModel.users[id];
    }
    TaskModel.tasks[task.details.id] = new Task(task.details.id, task.details.group_id, GroupModel.groups[task.details.group_id].name, 
      task.details.title, task.details.description, task.details.user_id, task.details.created_at, 
      task.details.due_date, members, task.details.finished_date);
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
      callback(JSON.parse(xhr.responseText));
    });
  };

  TaskModel.deleteTask = function(taskID, callback) {
    $.post("/delete_task", 
      {
        "task[id]": taskID
      })
      .success(function(data, status) { // on success, there will be message to console
        console.log("task delete Success: " );
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        console.log("task delete error: ");
        callback(JSON.parse(xhr.responseText));
      });
  }

  TaskModel.editTask = function(taskID, groupID, name, description, dateDue, finished, members, callback, generatorID) {
    // toastr.warning("edit task is called. change 'editTask' function in Taskmodel.js to implement");

    // if task was originally special
    if (generatorID) {
      // first remove the original task
      TaskModel.deleteTaskSpecial(generatorID, function(error){
        if (error){
          callback(error);
        } else {
          // then create a normal task
          TaskModel.createTask(groupID, name, description, dateDue, members, callback);

          delete TaskModel.tasks[taskID];
        }
      });
    

    } else {
      $.post("/edit_task", 
      {
        "task[id]": taskID,
        "task[group_id]": groupID,
        "task[title]": name,
        "task[description]": description,
        "task[due_date]": dateDue,
        "task[finished]": finished,
        "task[members]": members
      })
      .success(function(data, status) { // on success, there will be message to console
        console.log("task edit Success: " , data);
        updateTask(data);
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        console.log("task edit error: ",error);
        callback(JSON.parse(xhr.responseText));
      });
    }

    
  };

  // Create a task that might be cycling or repeating
  TaskModel.createTaskSpecial = function(groupID, name, description, dateDue, members, cycle, repostArray, callback) {
     $.post("/create_special_task", // <<----- url can be changed.
    {
      "task[group_id]": groupID,
      "task[title]": name,
      "task[description]": description,
      "task[due_date]": dateDue,   // <-- repeating tasks should know when to stop repeating as well
      "task[members]": members,
      "task[cycle]": cycle,
      "task[repeat_days]": repostArray,
      "task[finished]": false
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task special create Success: " , data);
      updateTask(data.task);
      updateGenerator(data.generator);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task special create error: ",error);
      callback(JSON.parse(xhr.responseText));
    });
  };

  TaskModel.deleteTaskSpecial = function(generatorID, callback) {
    $.post("/delete_special_task", 
      {
        "task[id]": generatorID
      })
      .success(function(data, status) { // on success, there will be message to console
        console.log("task special delete Success: " );
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        console.log("task special delete error: ");
        callback(JSON.parse(xhr.responseText));
      });
  }

  TaskModel.editTaskSpecial = function(taskID, groupID, name, description, dateDue, finished, members, cycle, repostArray, callback, generatorID) {
    //toastr.warning("edit task special is called. change 'editTaskSpecial' function in Taskmodel.js to implement");

    // if originally normal task
    if (!generatorID){
      TaskModel.deleteTask(taskID, function(error){
        if (error){
          callback(error);
        } else {
          // then create a normal task
          TaskModel.createTaskSpecial(groupID, name, description, dateDue, members, cycle, repostArray, callback);
          delete TaskModel.tasks[taskID];
        }
      });

      
    } else {
      $.post("/edit_special_task", 
      {
        "task[id]": generatorID,
        "task[group_id]": groupID,
        "task[title]": name,
        "task[description]": description,
        "task[due_date]": dateDue,
        "task[members]": members,
        "task[cycle]": cycle,
        "task[finished]": finished,
        "task[repeat_days]": repostArray
      })
      .success(function(data, status) { // on success, there will be message to console
        console.log("task edit special Success: " , data);
        delete TaskModel.tasks[taskID];
        updateTask(data.task);
        updateGenerator(data.generator);
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        console.log("task edit special error: ",error);
        callback(JSON.parse(xhr.responseText));
      });
    }

    
  };

  //Set the given task as finished, and update to the database
  TaskModel.setFinished = function(taskID, callback) {
    if(!taskID) {
      callback("no task id provided");
    }

    $.post("/finish_task",
    {
      "task[id]": taskID
    })
    .success(function(data, status) {
      updateTask(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
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
}]);
