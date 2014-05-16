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
