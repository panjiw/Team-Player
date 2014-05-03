/**
  TeamPlayer -- 2014

  This file is the controller for the login page.

  It provides the logic for logging in, or creating a user.
  On success, the user is redirected to the home screen. 
  On failure, the user is redirected to the 
*/

angular.module('myapp').controller("loginViewController", ["$scope", "UserModel", function($scope, UserModel) {

	// Log out the user, or display why it failed
	$scope.logout = function(e) {
		UserModel.logout(function(error) {
			if(error) {
				//TODO deal with errors
                document.getElementById("login-error").style.display = "inline";
				document.getElementById("login-error").innerHTML = error;
			} else {
			}
		});
	}

	//Try to login the user with the parameters provided in the form,
	//or display an error message indicating why it failed
	$scope.login = function(e) {
		UserModel.login($scope.login_uname, $scope.login_psswd, function(error) {
			if(error) {
				//TODO deal with errors
                document.getElementById("login-error").style.display = "inline";
				document.getElementById("login-error").innerHTML = error;
			} else {
				$scope.me = UserModel.get(UserModel.me);
				$scope.login_uname = $scope.login_psswd = "";
			}
		});
	}

	//Try to create a new user account with the parameters provided in the form,
	//or display an error message indicating why it failed
	$scope.createAccount = function(e) {

		var response = UserModel.createAccount($scope.create_fname, $scope.create_lname, 
												$scope.create_uname, $scope.create_email, $scope.create_psswd_one,
												$scope.create_psswd_two, function(error) {

			if(error) {
				//TODO deal with errors
                document.getElementById("login-error").style.display = "inline";
				document.getElementById("login-error").innerHTML = error;
			} else {
				$scope.create_fname = $scope.create_lname = $scope.create_uname = $scope.create_email = $scope.create_psswd_one = $scope.create_psswd_two = "";
				//window.location = "/home";
			}
		});
	}
}]);
