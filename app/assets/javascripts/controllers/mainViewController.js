/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("mainViewController", ["$scope", "UserModel", function($scope, UserModel) {
	$scope.activeTab = "selected_home";

	// Log out the user, or display why it failed
	$scope.logout = function(e) {
		UserModel.logout(function(error) {
			if(error) {
				//TODO deal with errors
				alert(error);
			} else {
				// Log out success, do nothing.
			}
		});
	}

}]);
