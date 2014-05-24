/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("mainViewController", ["$scope", "UserModel", "GroupModel", 
  function($scope, UserModel, GroupModel) {

  // initialize tab to home, and initialize bill tab to "you owe" view
	$scope.activeTab = "selected_home";
  $scope.activeBillTab = "bill_selected_you_owe";
  $scope.currentUser = {};

  // get the current logged on user from server
  UserModel.fetchUserFromServer(function(error){
  	if(error){
  	} else {
  		$scope.$apply(function(){
  			$scope.currentUser = UserModel.users[UserModel.me];
  		})
  		console.log("fetch user success!");
  	}
  });

  // use watch to update the view on username
  $scope.$watch('currentUser', function(newVal, oldVal){});

	// Log out the user, or display why it failed
	$scope.logout = function(e) {
		UserModel.logout(function(error) {
			if(error) {
				// display every error
        for (var index in error){
          toastr.error(error[index]);  
        }
			} else {
				// Log out success, do nothing.
			}
		});
	}

}]);
