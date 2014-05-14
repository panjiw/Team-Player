/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("homeViewController", 
	["$scope", "UserModel", "GroupModel", "TaskModel", "BillModel", 
	function($scope, UserModel, GroupModel, TaskModel, BillModel) {

  $scope.groupsList = {};

	GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
      console.log("fetch group error:");
      console.log(error);
    } else {
      function groupsToApply() {
        $scope.groupsList = groups;
      }
      if(asynch) {
        $scope.$apply(groupsToApply);
      } else {
        groupsToApply();
      }
    }
  });

  $('#addTaskBut').click(function(){
  	$('#taskModal').modal({show:true})
  });
  
  $('#addBillBut').click(function(){
  	$('#billModal').modal({show:true})
  });
}]);
