/*
  TeamPlayer -- 2014

  This file holds the model for all tasks the user is part of.

  It's main functionality is to get, create, and edit tasks.
*/

var Group = function(id, isSelfGroup, title, description, creator, dateCreated, members) {
	this.id = 0;
  this.isSelfGroup = false;
	this.title = "";
	this.description = "";
	this.creator = 0;
	this.dateCreated = null;
	this.members = [];
}

angular.module("myapp").factory('GroupModel', ['UserModel', function(UserModel) {
  var GroupModel = {};
  GroupModel.groups = {};   //ID to groups


  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  GroupModel.createGroup = function(title, description, dateCreated, members) { // creator ID
    //TODO
  };

  //Update any or all of these fields for the group with the groupID (which is required).
  //If a field is null, that field is not updated. If the groupID is not found,
  //indicates failure...
  GroupModel.editGroup = function(groupID, title, description, members) {
    //TODO
  };

  // Add a user into a group. If the user is already in the group, does nothing and return true. 
  // If adding fails (e.g. user does not exist), return false.
  GroupModel.addToGroup = function(groupID, userID) {
    //TODO
  }

  // Remove a user from a group. If the user is not in the group, does nothing and return true. 
  // If removing fails (e.g. user does not exist), return false.
  GroupModel.removeFromGroup = function(id, userID) {
  	//TODO
  }

  //Return all groups for this user as a list of Group objects
  GroupModel.getGroups = function() {
    //TODO ajax

    //Dummy objects for now
    var selfGroup = new Group(0, true, "SELF", "SELF_GROUP", 0, new Date(), [0]);
		var fakeGroup = new Group(0, false, "fake", "fake group!", 0, new Date(), [0, 1]);

    return [selfGroup, fakeGroup];
  }

  return GroupModel;
}]);
