var myApp = angular.module('myapp')
myApp.controller("UserController", ["$scope", "UserModel", function($scope, UserModel) {
	console.log("Hello, scope" + $scope);
	$scope.message = "Hello, world";
}]);