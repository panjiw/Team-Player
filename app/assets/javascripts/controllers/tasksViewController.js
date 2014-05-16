/**
 *  TeamPlayer -- 2014
 *
 *  This file is not yet implemented.
 *  It will be the controller for the tasks page when implemented
 */
angular.module('myapp').controller("tasksViewController", ["$scope", "TaskModel", "GroupModel", 
  function($scope, TaskModel, GroupModel) {

  function initNewTaskData(){
    $scope.newTaskGroup = -1;
    $scope.newTaskTitle = "";
    $scope.newTaskDescription = "";
    $scope.newTaskDateDue = "";
    $scope.newTaskMembers = {};
    $scope.newTaskCycle = false;
    $scope.newTaskRepostArray = [];
  }

  initNewTaskData();

  $scope.addTask_members = [];

  $scope.groupsList = {};
  $scope.currentMembers = {};

  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
    }
  });

  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('groupList in task changed');
  });

  $scope.$watch('newTaskGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = $scope.newTaskGroup.members;
  });
 
  $scope.openModal = function(e){
    $('#myModal').modal({show:true})
  };

  $scope.addMember = function(e) {
    if(e.which != 13) {   // If they didn't press enter, we don't care
      return;
    }

    $scope.addTask_members.push($scope.newMember);
    $scope.newMember = "";
  }

  $scope.testingSendID = function(e){

    $.post("/task_id", // <<----- url can be changed.
    {
      "task[task_id]": 2 // <-- change it as you like

    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("task send id Success: " , data);
      // update task
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("task send id error: ",error);
    });
  }

  $scope.createTask = function(e){
    TaskModel.createTask(newTaskGroup, newTaskTitle, newTaskDescription, dateDue, newTaskDateDue, 
      // newTaskCycle, newTaskRepostArray, 
      function(error){
        if(error){
          //TODO
        } else {

        }
      });
  }

  $scope.testingCreateTask = function(e){
    //dummy tasks data; change it for testing!
    var groupID = 4;
    var title = "task for groupid 4";
    var description = "this is a good task 4";
    var dateDue = new Date();
    var members = [1,3];
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



  $scope.myTasks = [
    {taskID: 'task1', taskName:'Clean Room', taskDesc: 'description', dueDate:'5/20/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task2', taskName:'Wash Dishes', taskDesc: 'description', dueDate:'5/22/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task3', taskName:'Take Out Trash', taskDesc: 'description', dueDate:'5/24/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task4', taskName:'Pay Water Bill', taskDesc: 'description', dueDate:'5/26/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task5', taskName:'Clean Bathroom', taskDesc: 'description', dueDate:'5/28/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task6', taskName:'Do Laundry', taskDesc: 'description', dueDate:'5/30/14', groupName:'GroupName', members:'membersList'}
  ];


  $scope.openTaskPop = function (p) {
    if ($('#' + p).is(':visible')) {
      $('#' + p).hide();
    }
    else {
      $('#' + p).show();
    }
    $('.tasks-pop').not('#' + p).hide();
  }

  $scope.openEditModal = function(e){
    $('#editModal').modal({show:true})
  };

}]);
