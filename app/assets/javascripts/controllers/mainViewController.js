/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("mainViewController", ["$scope", "UserModel", "GroupModel", 
  function($scope, UserModel, GroupModel) {
	$scope.activeTab = "selected_home";
    $scope.activeBillTab = "bill_selected_you_owe";
    $scope.currentUser = {};

  UserModel.fetchUserFromServer(function(error){
  	if(error){
  		//TODO
  	} else {
  		$scope.$apply(function(){
  			$scope.currentUser = UserModel.users[UserModel.me];
  		})
  		console.log("fetch user success!");

  	}
  });

  GroupModel.getGroups(function(groups, asynch, error) {
      if (error){
        console.log("fetch group error:");
        console.log(error);
      } else {
        function groupsToApply() {
          console.log("Got groups:");
          console.log(groups);
          $scope.groupsList = groups;
        }
        if(asynch) {
          $scope.$apply(groupsToApply);
        } else {
          groupsToApply();
        }
      }
    });

  $scope.$watch('currentUser', function(newVal, oldVal){
    console.log('currentUser changed');
  });

  $scope.printUser = function(){
    console.log("Users: ",UserModel.users);
  }

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
  
  $scope.openPop = function (e) {
        $('.btn').not(e.target).popover('hide');
  };

}]);
