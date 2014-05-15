/**
 *  TeamPlayer -- 2014
 *
 *  This file is not yet implemented.
 *  It will be the controller for the tasks page when implemented
 */
angular.module('myapp').controller("tasksViewController", ["$scope", "TaskModel", function($scope, TaskModel) {

	$scope.addTask_members = [];
 
  $scope.openModal = function(e){
  	$('#myModal').modal({show:true})
  };

  $scope.addMember = function(e) {
  	if(e.which != 13) {		// If they didn't press enter, we don't care
  		return;
  	}

  	$scope.addTask_members.push($scope.newMember);
  	$scope.newMember = "";
  }

  $scope.testingCreateTask = function(e){
    //dummy tasks data; change it for testing!
    var groupID = 2;
    var title = "task 1";
    var description = "this is a good task";
    var dateDue = new Date();
    var members = [2,1];
    var finished = false;


    $.post("/create_task", // <<----- url can be changed.
    {
      "task[group_id]": groupID,
      "task[title]": title,
      "task[description]": description,
      "task[due_date]": dateDue,
      "task[members]": members,
      "task[finished]": finished
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task create Success: " , data);
      // update task
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task create error: ",error);
    });
  }

  $scope.testingCreateTaskSpecial = function(e){
    //dummy tasks data; change it for testing!
    var groupID = 2;
    var title = "special task 1";
    var description = "this is a cycling repeating task";
    var members = [1,2];
    var cycle = false; // cycle within members
    var repostArray = [false,true,false,false,false,false,false]; //repeat every monday
    var finished = false;


    $.post("/create_task_special", // <<----- url can be changed.
    {
      "task[group_id]": groupID,
      "task[title]": title,
      "task[description]": description,
      "task[members]": members,
      "task[cycle]": cycle,
      "task[repeat_days]": repostArray,
      "task[finished]": finished
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task special create Success: " , data);
      // update task
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task special create error: ",error);
    });
  }

  $scope.testingGetTask = function(e){

    $.get("/get_task") // <-- url can be changed!
    .success(function(data, status) { // on success, there will be message to console
      console.log("task get Success: " , data);
      // update task
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task get error error: ",error);
    });
  }



}]);
