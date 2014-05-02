var myApp = angular.module('myapp')
myApp.controller("GroupController", ["$scope", "GroupModel", function($scope, GroupModel) {
	$scope.groups = GroupModel.getGroups();

	$scope.print = function () {
		console.log(GroupModel.getUserInvolved(0).uname);
	}

	$scope.createGroup = function(e) {
		//TODO
	};

	$scope.editGroup = function(e) {
		//TODO
	};

	$scope.addToGroup = function(e) {
		//TODO
	};

	$scope.removeFromGroup = function(e) {
		//TODO
	};



}]);