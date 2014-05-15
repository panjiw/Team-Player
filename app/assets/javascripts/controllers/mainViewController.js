/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("mainViewController", ["$scope", "UserModel","GroupModel", 
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
        GroupModel.getGroups(function(groups,asynch,error){
          if(error){
            console.log("main get group error!");
          } else {
            console.log("main get users:",UserModel.users);
          } 
        });
  		})
  		console.log("fetch user success!");

  	}
  });

  

  $scope.$watch('currentUser', function(newVal, oldVal){
    console.log('currentUser changed');
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
  
  $scope.openPop = function (e) {
        $('.btn').not(e.target).popover('hide');
  };

}]);
