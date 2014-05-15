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
    {taskName:'Clean Room', dueDate:'5/20/14', groupName:'Group Name', members:'membersList'},
    {taskName:'Wash Dishes', dueDate:'5/22/14', groupName:'Group Name', members:'membersList'},
    {taskName:'Take Out Trash', dueDate:'5/24/14', groupName:'Group Name', members:'membersList'},
    {taskName:'Pay Water Bill', dueDate:'5/26/14', groupName:'Group Name', members:'membersList'},
    {taskName:'Clean Bathroom', dueDate:'5/28/14', groupName:'Group Name', members:'membersList'},
    {taskName:'Do Laundry', dueDate:'5/30/14', groupName:'Group Name', members:'membersList'}
  ];


  $scope.openTaskPop = function (p) {
    if ($('#' + p + 'info').is(':visible')) {
      $('#' + p + 'info').show();
    }
    else {
      $('#' + p + 'info').hide();
    }
    $('.tasks-pop').not('#' + p + 'info').hide();
  }

}]);
