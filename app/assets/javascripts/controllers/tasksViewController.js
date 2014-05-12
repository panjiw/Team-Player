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
}]);
