
angular.module('myapp').controller("loginViewController", ["$scope", "UserModel", function($scope, UserModel) {
	$scope.login = function(e) {
		var response = UserModel.login($scope.login_uname, $scope.login_psswd);

		if(response) {
			//TODO error codes
		} else {
			$scope.me = UserModel.me;
		}
	}

	$scope.createAccount = function(e) {

		console.log("controller");
		var response = UserModel.createAccount($scope.create_fname, $scope.create_lname, 
												$scope.create_uname, $scope.create_email, $scope.create_psswd_one,
												$scope.create_psswd_two);

		if(response) {
			//TODO error codes
		} else {	//Success!
			$scope.create_fname = $scope.create_lname = $scope.create_uname = $scope.create_email = $scope.create_psswd_one = $scope.create_psswd_two = "";
		}
	}
}]);
