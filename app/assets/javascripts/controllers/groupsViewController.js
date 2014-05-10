/*
* TeamPlayer -- 2014
*
* This file is not implemented yet. It will be
* the controller for the groups page
*/
 angular.module('myapp').controller("groupsViewController",
     ["$scope", "UserModel", "GroupModel", function($scope, UserModel, GroupModel) {

  $scope.user = {};
  // default select group with id 0
  $scope.group_selected = 0;
  $scope.groupsList = GroupModel.getGroups();

  $scope.newMemberList = [];

  $scope.showAddGroup = function(e){
    $('#myModal').modal({show:true});
  }

  // experimental code; when the second line of
  // this function gets called, the view will be updated.
  // the second line is required, since it updates the $scope variable.
  // $scope.change = function(e) {
  // GroupModel.groups[3] = new Group(2, false, "geo", "geo post description", 0, new Date(), [0]);
  // $scope.groupsList= GroupModel.getGroups();
  // }

  $scope.createGroup = function(e) {
    if(!($scope.groupCreateName && $scope.groupCreateDescription)) {
      e.preventDefault();
      toastr.error("Empty fields");
      return;
    }

    console.log("Trying to create a group...");

    GroupModel.createGroup($scope.groupCreateName, $scope.groupCreateDescription, $scope.newMemberList,
    function(error) {
      if (error){
        toastr.error(error);
      } else {
        $scope.$apply(function() {
          $scope.groupsList = GroupModel.getGroups();
          $scope.groupCreateName = $scope.groupCreateDescription = $scope.newMember = "";
          $scope.newMemberList = [];
        });
      }
    });
  }


  $scope.checkByEmail = function(e) {
    if(e.which != 13) {   // didn't press enter
      return;
    }

    function indexOfId(array, el) {
      for(var i = 0; i < array.length; i++) {
        if(array[i].id == el.id) {
          return i;
        }
      }
      return -1;
    }

    GroupModel.checkByEmail($scope.newMember, function(user, error) {
      if(error) {
        toastr.error(error);
      } else {
        console.log(user);
        $scope.$apply(function() {
          console.log(user);
          if(indexOfId($scope.newMemberList, user) == -1) {
            $scope.newMemberList.push(user);
            console.log($scope.newMemberList);
          }
        });
      }
    });

    $scope.newMember = "";
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
