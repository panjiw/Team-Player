/*
* TeamPlayer -- 2014
*
* This file is not implemented yet. It will be
* the controller for the groups page
*/
 angular.module('myapp').controller("groupsViewController",
     ["$scope", "UserModel", "GroupModel", function($scope, UserModel, GroupModel) {

  // default select group with id -1
  $scope.group_selected = -1;
  $scope.member_selected = -1
  $scope.currentMemebrs = {};
  
  GroupModel.fetchGroupsFromServer(function(error){
    if(error){
      //TODO
    } else {
      $scope.groupsList = GroupModel.getGroups();
      if(Object.getOwnPropertyNames($scope.groupsList).length === 0){
        $scope.group_selected = Object.keys($scope.groupsList)[0];
        if($scope.group_selected != -1) {
          $scope.member_selected = $scope.groupsList[$scope.group_selected].members[0].id;
          if($scope.member_selected != -1){
            $scope.currentMemebrs = $scope.groupsList[$scope.group_selected].members;    
          }
        }
      }
    }
  });

  $scope.user = {};
  

  

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

  $scope.selectGroup = function(id) {
    $scope.group_selected = id;
    $scope.currentMemebrs = $scope.groupsList[id].members;
    $scope.member_selected = -1;
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
          if(indexOfId($scope.newMemberList, user) == -1) {
            $scope.newMemberList.push(user);
          }
        });
      }
    });

    $scope.newMember = "";
  }

}]);
