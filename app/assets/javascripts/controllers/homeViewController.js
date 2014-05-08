/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("homeViewController", ["$scope", "TaskModel", function($scope, TaskModel) {

  $('#addTaskBut').click(function(){
  	$('#taskModal').modal({show:true})
  });
  
  $('#addBillBut').click(function(){
  	$('#billModal').modal({show:true})
  });


}]);
