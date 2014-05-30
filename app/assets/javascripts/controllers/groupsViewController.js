/*
* TeamPlayer -- 2014
*
* This is the Angular Controller for the viewing groups page.
* It contains the logic for adding, editing, leaving, and viewing groups
*/
 angular.module('myapp').controller("groupsViewController",
     ["$scope", "$timeout", "UserModel", "GroupModel", "TaskModel", "BillModel",
     function($scope, $timeout, UserModel, GroupModel, TaskModel, BillModel) {

  // Set $scope variables to defaults 
  $scope.group_selected = -1;
  $scope.member_selected = -1
  $scope.currentMembers = {};
  $scope.groupsList = GroupModel.groups;
  $scope.currentUser = UserModel.get(UserModel.me);
  $scope.newMemberList = [$scope.currentUser];
  
  // synchronize the group list and current user
  // with those of the appropriate models
  $scope.$watch('groupsList', function(newVal, oldVal) {
    $scope.groupsList = newVal;
    if(Object.keys($scope.groupsList).length != 0) {
      console.log("Entered watch");
      for(var group in $scope.groupsList) {
        console.log($scope.groupsList[group]);
        if($scope.groupsList[group].isSelfGroup) {
          $scope.group_selected = group;
          $scope.currentMembers = $scope.groupsList[group].members;
        }
      }
    }
  });
  $scope.$watch('currentUser', function(newVal, oldVal) {});

  $scope.createGroup = function(e) {
    // basic error checking
    if(!$scope.groupCreateName || !$scope.groupCreateDescription) {
      e.preventDefault();

      if(!$scope.groupCreateName)
        toastr.error("Group Name Required");
      
      if (!$scope.groupCreateDescription)
        toastr.error("Group Description Required");
      return;
    }

    GroupModel.createGroup($scope.groupCreateName, $scope.groupCreateDescription, $scope.newMemberList,
    function(error) {
      if (error){
        toastr.error(error);
      } else {
        // clear input boxes and hide the modals
        $scope.$apply(function() {
          $scope.groupCreateName = $scope.groupCreateDescription = $scope.newMember = "";
          $scope.newMemberList = [$scope.currentUser];
          toastr.success("Group created!");
        });
        $('#groupModal').modal('hide');
      }
    });
  }

  // try to add the member to the current selected group,
  // or display an error message if the user was not found
  $scope.addMember = function(e) {
    // we only add on clicking on the add member button or
    // pressing enter in the input box
    if(e.type != "click" && e.which != 13) {
      return;
    }

    var groupid = $scope.group_selected;
    GroupModel.addMember(groupid, $scope.addNewMember, function(error) {
      if (error){
        toastr.error(error);
      } else {
        // clear input boxes and hide the modals
        $scope.$apply(function() {
          $scope.currentMembers = $scope.groupsList[groupid].members;
          $scope.member_selected = -1;
          $scope.addNewMember = "";
        });
      }
    });
  }

  // edit the title or description of a group.
  // the members and id's of groups cannot be changed.
  $scope.editGroup = function(e) {
    var id = $scope.groupsList[$scope.group_selected].id;
    GroupModel.editGroup(id, $scope.editName, $scope.editDescription, function(error) {
      if(error) {
        toastr.error(error);
      } else {
        $scope.$apply(function() {
          $scope.editDescription = $scope.editName = "";
          $('#editModal').modal('hide');
        });
      }
    });
  }

  // leave the current selected group. This will
  // clear your tasks and bills from this group
  $scope.leaveGroup = function(id) {
    GroupModel.leaveGroup(id, function(error) {
      if(error) {
        toastr.error(error);
      } else {
        $scope.$apply(function() {
          $scope.groupsList = GroupModel.groups;
          $scope.group_selected = Object.keys($scope.groupsList)[0];
          $scope.currentMembers = $scope.groupsList[$scope.group_selected].members;
          $scope.member_selected = -1;
        });
      }
    }, TaskModel, BillModel);
  }

  // called when the user selects a different group on the UI
  $scope.selectGroup = function(id) {
    $scope.group_selected = id;
    $scope.currentMembers = $scope.groupsList[id].members;
    $scope.member_selected = -1;
  }

  // Check to see whether a user with a given email is a valid user
  // in Team-Player. If so, add them to the list of newMembers
  // so it shows up in the UI
  $scope.checkByEmail = function(e) {
    if(e.which != 13 && e.type != "click") {   // didn't press enter or click
      return;
    }

    // find an element by id in the array of objects
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
        $scope.$apply(function() {
          // cannot add twice
          if(indexOfId($scope.newMemberList, user) == -1) {
            $scope.newMemberList.push(user);
            $scope.newMember = "";
          }
        });
      }
    });
  }

  ////////////////////////////////////////////////////////////
  //  Modal functionality -- open and close modals as needed
  /////////////////////////////////////////////////////////////

  $scope.showAddGroup = function(e){
    $('#groupModal').modal({show:true});
    $('.modal-content').css('height',$( window ).height()*0.8);
  }

  $scope.showEditGroup = function(e) {
    $scope.editName = $scope.groupsList[$scope.group_selected].name;
    $scope.editDescription = $scope.groupsList[$scope.group_selected].description;
    $('#editModal').modal({show:true});
  }

  $scope.openGroupHelpModal = function(e){
    $('#groupHelpModal').modal({show:true})
  };

  $scope.groupNext = function(pageNum) {
    $('#'+'groupHelp'+pageNum).hide();
    $('#'+'groupHelp'+(parseInt(pageNum)+1)).show();
  }

  $scope.groupBack = function(pageNum) {
    $('#'+'groupHelp'+pageNum).hide();
    $('#'+'groupHelp'+(parseInt(pageNum)-1)).show();
  }
}]);
