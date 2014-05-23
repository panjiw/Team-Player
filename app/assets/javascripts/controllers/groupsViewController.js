/*
* TeamPlayer -- 2014
*
* This file is not implemented yet. It will be
* the controller for the groups page
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
  $scope.$watch('groupsList', function(newVal, oldVal) {});
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
    });
  }

  // try to add the member to the current selected group
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

  $scope.editGroup = function(e) {
    var id = $scope.groupsList[$scope.group_selected].id;
    GroupModel.editGroup(id, $scope.editName, $scope.editDescription, function(error) {
      if(error) {
        toastr.error(error);
      }
      $('#editModal').modal('hide');
    });

    $scope.editDescription = $scope.editName = "";
  }

  $scope.leaveGroup = function(id) {
    GroupModel.leaveGroup(id, function(error) {
      if(error) {
        toastr.error(error);
      } else {
        updateGroups();
      }
    }, TaskModel, BillModel);
  }

  $scope.selectGroup = function(id) {
    $scope.group_selected = id;
    $scope.currentMembers = $scope.groupsList[id].members;
    $scope.member_selected = -1;
  }

  $scope.checkByEmail = function(e) {
    if(e.which != 13 && e.type != "click") {   // didn't press enter or click
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
        $scope.$apply(function() {
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
