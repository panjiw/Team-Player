var myApp = angular.module('myapp')
myApp.controller("TaskController", ["$scope", "TaskModel", function($scope, TaskModel) {
	$scope.tasks = TaskModel.getTasks();

	$scope.addTask = function(e) {
		//TODO
	};

	$scope.editTask = function(e) {
		//TODO
	};

	$scope.setFinished = function(e) {
		//TODO
	};
}]);