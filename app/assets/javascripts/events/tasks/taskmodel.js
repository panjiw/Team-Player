/*
  TeamPlayer -- 2014

  This file holds the model for all tasks the user is part of.

  It's main functionality is to get, create, and edit tasks.
*/

//Define a task object as an event with additional fields:
//  --id: the task's id
//  --group: the group with which this task is associated
//  --title: the title of the task
//  --description: a more detailed description of the task
//  --creator: the id of the creator of this task
//  --dateCreated: the date on which the task was created
//  --dateDue: the date on which the task is due (can be empty for dateless dask)
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
  TaskModel.tasks = {};             // ID to task
  TaskModel.generators = {};        // ID to task generator
  TaskModel.fetchedTasks = false;   // we have not got tasks from model yet

  // get Tasks from server to Task model.
  TaskModel.refresh = function(callback) {
    $.get("/get_task")
    .success(function(data, status) {
      // make sure to clear old tasks in case any have been deleted
      TaskModel.tasks = {};
      for (var i in data){
        updateTask(data[i]);
      }

      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });

     $.get("/get_generators")
    .success(function(data, status) {
      console.log("gen",data);
      // update task generator
      for (var i in data){
        updateGenerator(data[i]);

      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });

  };

  function updateGenerator(generator){
    TaskModel.generators[generator.details.current_task_id] = generator;
  }

  // get Tasks from server to Task model.
  TaskModel.getTaskGeneratorsFromServer = function(callback) {
    $.get("/get_generators")
    .success(function(data, status) {
      // update task generator
      for (var i in data){
        updateGenerator(data[i]);
      }
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      callback(error);
    });
  };

  // update a task into the TaskModel.tasks map
  function updateTask(task){
    var members = {};

    // grab the entire user objects for each user from the model
    for (var id in task.members){
      members[id] = UserModel.users[id];
      if(!members[id].rank) members[id].rank = {};
      members[id].rank[task.details.id] = task.members[id];
    }

    // update or add to our saved tasks
    var created_at = formatDate(task.details.created_at);
    var due_date = formatDate(task.details.due_date);
    var finished_date = formatDate(task.details.finished_date);
    TaskModel.tasks[task.details.id] = new Task(task.details.id, task.details.group_id, GroupModel.groups[task.details.group_id].name, 
      task.details.title, task.details.description, task.details.user_id, created_at, due_date, members, finished_date);
  }

  TaskModel.createTask = function(groupID, name, description, dateDue, members, callback) {
    $.post("/create_task",
    {
      "task[group_id]": groupID,
      "task[title]": name,
      "task[description]": description,
      "task[due_date]": dateDue,
      "task[members]": members,
      "task[finished]": false
    })
    .success(function(data, status) {
      updateTask(data);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // delete a given task. Note: only the creator of a task
  // can delete it--an error message will be displayed otherwise
  TaskModel.deleteTask = function(taskID, callback) {
    $.post("/delete_task", 
    {
      "task[id]": taskID
    })
    .success(function(data, status) {
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  }

  TaskModel.editTask = function(taskID, groupID, name, description, dateDue, finished, members, callback, generatorID) {
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
        updateTask(data);
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        callback(JSON.parse(xhr.responseText));
      });
    }  
  };

  // Create a task that might be cycling or repeating
  TaskModel.createTaskSpecial = function(groupID, name, description, dateDue, members, cycle, repostArray, callback) {
     $.post("/create_special_task",
    {
      "task[group_id]": groupID,
      "task[title]": name,
      "task[description]": description,
      "task[due_date]": dateDue,   // repeating tasks should know when to stop repeating as well
      "task[members]": members,
      "task[cycle]": cycle,
      "task[repeat_days]": repostArray,
      "task[finished]": false
    })
    .success(function(data, status) {
      updateTask(data.task);
      updateGenerator(data.generator);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // delete a "special" task--i.e. one that either repeats
  // or cycles based on its task generator.
  TaskModel.deleteTaskSpecial = function(generatorID, callback) {
    $.post("/delete_special_task", 
      {
        "task[id]": generatorID
      })
      .success(function(data, status) {
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
        callback(JSON.parse(xhr.responseText));
      });
  }

  TaskModel.editTaskSpecial = function(taskID, groupID, name, description, dateDue, finished, 
                                        members, cycle, repostArray, callback, generatorID) {
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
      .success(function(data, status) {
        delete TaskModel.tasks[taskID];
        updateTask(data.task);
        updateGenerator(data.generator);
        callback();
        
      })
      .fail(function(xhr, textStatus, error) {
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
      // delete the given task, or if it is special,
      // set the appropriate properties inside it
      // marking that one iteration is finished
      delete TaskModel.tasks[taskID];
      if (data.task){
        updateTask(data.task);
        updateGenerator(data.generator);
      }
        
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // Stop a special task from repeating, which means set the given task generator as finished
  TaskModel.stopRepeat = function(taskID, callback) {
    if(!taskID) {
      callback("no task id provided");
    }

    $.post("/finish_special_task",
    {
      "task[id]": TaskModel.generators[taskID].details.id
    })
    .success(function(data, status) {

      // delete TaskModel.tasks[taskID];
      updateGenerator(data);
        
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  return TaskModel;
}]);
