var myApp = angular.module('myapp')
myApp.controller("UserController", ["$scope", "UserModel", function($scope, UserModel) {
	console.log("Hello, scope" + $scope);
	$scope.message = "Hello, world";

	$scope.createAccount = function(e) {
		var response = UserModel.createAccount($scope.create_fname, $scope.create_lname, 
												$scope.create_uname, $scope.create_psswd_one, 
												$scope.create_psswd_two);

		if(response) {
			//TODO error codes
		} else {	//Success!
			$scope.create_fname = $scope.create_lname = $scope.create_uname = $scope.create_psswd_one = $scope.create_psswd_two = "";
		}
	}
}]);