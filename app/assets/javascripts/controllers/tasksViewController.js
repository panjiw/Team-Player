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
    $scope.newTaskRepostArray = [false,false,false,false,false,false,false];
  }

  $scope.prt = function(){
    filterUnchecked();
    console.log("$scope.newTaskGroup", $scope.newTaskGroup);
    console.log("$scope.newTaskTitle", $scope.newTaskTitle);
    console.log("$scope.newTaskDescription", $scope.newTaskDescription);
    console.log("$scope.newTaskDateDue", $scope.newTaskDateDue);
    console.log("$scope.newTaskMembers", $scope.newTaskMembers);
    console.log("$scope.newTaskCycle", $scope.newTaskCycle);
    console.log("$scope.newTaskRepostArray", $scope.newTaskRepostArray);
  }

  function filterUnchecked(){
    $scope.newTaskMembers = [];
    for(var index in $scope.currentMembers){
      if($scope.currentMembers[index].chked){
        $scope.newTaskMembers[index] = $scope.currentMembers[index];
      }
    }
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
    console.log("currentMembers, ", $scope.currentMembers);
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



  $scope.myTasks = [
    {taskID: 'task1', taskName:'Clean Room', taskDesc: 'description', dueDate:'5/20/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task2', taskName:'Wash Dishes', taskDesc: 'description', dueDate:'5/22/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task3', taskName:'Take Out Trash', taskDesc: 'description', dueDate:'5/24/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task4', taskName:'Pay Water Bill', taskDesc: 'description', dueDate:'5/26/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task5', taskName:'Clean Bathroom', taskDesc: 'description', dueDate:'5/28/14', groupName:'GroupName', members:'membersList'},
    {taskID: 'task6', taskName:'Do Laundry', taskDesc: 'description', dueDate:'5/30/14', groupName:'GroupName', members:'membersList'}
  ];

  $scope.openTaskPop = function (e, p) {
    if ($('#' + p).is(':visible')) {
      $('#' + p).hide();
      $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
    }
    else {
      $('#' + p).show();
      $(e.target).find(".panel-heading").css("background-color", "#52d600");
    }
    $('.tasks-pop').not('#' + p).hide();
    $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
  }

  $scope.openEditModal = function(e){
    $('#editModal').modal({show:true})
  };

}]);
