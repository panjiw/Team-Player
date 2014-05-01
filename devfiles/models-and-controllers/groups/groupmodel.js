// **NOTE: specs such as return values are not set in stone.

var Group = function() {
	this.isSelfGroup = false;
	this.id = 0;
	this.title = "";
	this.description = "";
	this.creator = 0;
	this.dateCreated = null;
	this.members = [];
}

angular.module("myapp").factory('GroupModel', function() {
  var GroupModel = {};
  GroupModel.groups = {};   //ID to groups

  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  GroupModel.createGroup = function(title, description, dateCreated, members) { // creator ID
    //TODO
  };

  //Update a group with all of the fields. If a field is null, it is not updated
  GroupModel.editGroup = function(id, title, description, dateCreated, members) {
    //TODO
  };

  // Add a user into a group. If the user is already in the group, does nothing and return true. 
  // If adding fails (e.g. user does not exist), return false.
  GroupModel.addToGroup = function(id, userID) {

  }

  // Remove a user from a group. If the user is not in the group, does nothing and return true. 
  // If removing fails (e.g. user does not exist), return false.
  GroupModel.removeFromGroup = function(id, userID) {
  	
  }

  //Return all groups for this user as a list of Group objects
  GroupModel.getGroups = function() {
  	
    var selfGroup = new Group();
    selfGroup.isSelfGroup = true;
		selfGroup.id = 0;
		selfGroup.title = "SELF";
		selfGroup.description = "SELF_GROUP";
		selfGroup.creator = 0;
		selfGroup.dateCreated = new Date();
		selfGroup.members = [0];

		var fakeGroup = new Group();
    fakeGroup.isSelfGroup = true;
		fakeGroup.id = 0;
		fakeGroup.title = "fake";
		fakeGroup.description = "fake group!";
		fakeGroup.creator = 0;
		fakeGroup.dateCreated = new Date();
		fakeGroup.members = [0];

    return [selfGroup, fakeGroup];
  }

  return GroupModel;
});
