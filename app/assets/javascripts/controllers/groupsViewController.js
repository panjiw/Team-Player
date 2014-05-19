/*
* TeamPlayer -- 2014
*
* This file is not implemented yet. It will be
* the controller for the groups page
*/
 angular.module('myapp').controller("groupsViewController",
     ["$scope", "$timeout", "UserModel", "GroupModel", function($scope, $timeout, UserModel, GroupModel) {

  // default select group with id -1
  $scope.group_selected = -1;
  $scope.member_selected = -1
  $scope.currentMembers = {};
  $scope.groupsList = {};
  $scope.currentUser = UserModel.get(UserModel.me);

  function getGroupsFromModel(callback) {
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
      if(callback) {
        callback();
      }
    });
  }

  getGroupsFromModel(function() {
    function getGroups(){
      if(Object.getOwnPropertyNames($scope.groupsList).length != 0){
        $scope.group_selected = Object.keys($scope.groupsList)[0];
        console.log("$scope.groupsList", $scope.groupsList);
        console.log("$scope.group_selected", $scope.group_selected);
        if($scope.group_selected != -1) {
          console.log("member selected",$scope.member_selected);
          $scope.currentMembers = $scope.groupsList[$scope.group_selected].members;    
          $scope.currentMembers = buildMemberMap($scope.currentMembers);
          console.log("$scope.currentMembers",$scope.currentMembers);
        }
      }
    }

    if(!$scope.$$phase && !$scope.$root.$$phase) {
      $scope.$apply(getGroups);
    } else {
      getGroups();
    }
  });

  function buildMemberMap(memberArray){
    var map = {};
    memberArray.forEach(function(mem){
        map[mem.id] = mem;
      });
    return map;
  }

  $scope.user = {};

  $scope.newMemberList = [$scope.currentUser];

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
        getGroupsFromModel();
        $scope.$apply(function() {
          $scope.groupCreateName = $scope.groupCreateDescription = $scope.newMember = "";
          $scope.newMemberList = [$scope.currentUser];
          toastr.success("Group created!");
        });
      }
    });
  }

  $scope.addMember = function(e) {
    if(e.type != "click" && e.which != 13) {
      return;
    }

    var groupid = $scope.group_selected;

    GroupModel.addMember(groupid, $scope.addNewMember, function(error) {
      if (error){
        toastr.error(error);
      } else {
        getGroupsFromModel(function() {
          $scope.$apply(function() {
            $scope.currentMembers = buildMemberMap($scope.groupsList[groupid].members);
            $scope.member_selected = -1;
            $scope.addNewMember = "";
          });
        });
      }
    });
  }

  $scope.selectGroup = function(id) {
    $scope.group_selected = id;
    $scope.currentMembers = buildMemberMap($scope.groupsList[id].members);
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
        console.log(user);
        $scope.$apply(function() {
          if(indexOfId($scope.newMemberList, user) == -1) {
            $scope.newMemberList.push(user);
            $scope.newMember = "";
          }
        });
      }
    });
  }
}]);
