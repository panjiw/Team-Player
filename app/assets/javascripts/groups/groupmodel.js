/*
TeamPlayer -- 2014

This file holds the model for all tasks the user is part of.

It's main functionality is to get, create, and edit tasks.
*/

var Group = function(id, isSelfGroup, name, description, creator, dateCreated, members) {
this.id = id;
  this.isSelfGroup = isSelfGroup;
this.name = name;
this.description = description;
this.creator = creator;
this.dateCreated = dateCreated;
this.members = members;
}

angular.module("myapp").factory('GroupModel', ['UserModel', function(UserModel) {
  var GroupModel = {};
  GroupModel.groups = {}; //ID to groups


  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise.
  //Note: The "members" array does not need to contain the creator. The creator
  //of a group will be placed in the group by default.
  GroupModel.createGroup = function(name, description, members, callback) {
    function extractIds(userList) {
      var userIds = [];
      for(user in userList) {
        userIds.push(user.id);
      }
      return userIds;
    }

    // create a group
    // current_user will set as creator, no need to send creator
    // current_user will be added to the group as member
    $.post("/create_group",
    {
      "group[name]": name,
      "group[description]": description,
      "group[members]": extractIds(members)
    })
    .success(function(data, status) {
      console.log("Success: " + data);
      GroupModel.groups[data.id] = new Group(data.id, false, data.name, data.description, 
                                              data.creator, data.dateCreated, data.members);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("group create error: "+error);
      callback("Error: " + JSON.parse(xhr.responseText));
    });
  };

  //Update any or all of these fields for the group with the groupID (which is required).
  //If a field is null, that field is not updated. If the groupID is not found,
  //indicates failure...
  GroupModel.editGroup = function(groupID, name, description, members) {
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

    var groupArray = [];

    for(var index in GroupModel.groups) {
      groupArray.push(GroupModel.groups[index]);
    }

    return groupArray;
  }

  GroupModel.checkByEmail = function(email, callback) {
    UserModel.getUserByEmail(email, function(user, error) {
      if(error) {
        callback(null, "User not found: " + email);
      } else {
        callback(user);
      }
    });
  }

  return GroupModel;
}]);
