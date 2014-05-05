/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the groups page
 */
 angular.module('myapp').controller("groupsViewController",
     ["$scope", "UserModel", "TaskModel", function($scope, UserModel, TaskModel) {

  $scope.user = {};

  $scope.check = function(e) {
    $scope.user = UserModel.getUserByEmail($scope.lookupEmail, function(user, error) {
      if(error) {
        toastr.error("User not found :(");
      } else {
        $scope.$apply(function() {
          $scope.user = user;
        });
      }
    });
  }

	// this function is for backend testing, not for release.
	$scope.sendForm = function(){
		console.log("keith, send a form!");

		// create a group
		// current_user will set as creator, no need to send creator
		// current_user will be added to the group as member
		$.post("/create_group",
		{
			"group[name]": "Jackson",
			"group[description]": "TierOne",
			"add[members]": ['1','2']
		});
		
/*
		//view all the groups user in
		$.post("/view_group",
		{
		});


		// given group ID, display list of users in group
		// current user MUST be in group
		$.post("/view_members",
		{
			"view[id]": "3"
		});	
		
		
   		// Invite Member to Group : email and Group ID to add to
		// current user must be in group
		// will not allow repeated, can't join group twice
		// will not break if no email found, no error message atm
		// return a list of user in this group, no email = original list
		$.post("/invite_to_group",
		{
			"invite[gid]" : "3",
			"invite[email]" : "asdfsdf@uw.edu"
		});
*/
	}

}]);
