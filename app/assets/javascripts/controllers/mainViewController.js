/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("mainViewController", ["$scope", "UserModel", function($scope, UserModel) {
	$scope.activeTab = "selected_home";
    $scope.activeBillTab = "bill_selected_you_owe";

  UserModel.fetchUserFromServer(function(error){
  	if(error){
  		//TODO
  	} else {
  		console.log("fetch user success!");
  	}
  });

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
