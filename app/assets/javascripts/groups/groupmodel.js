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
  this.members = {};
  for (var i in members){
    this.members[members[i].id] = members[i];
  }
}

angular.module("myapp").factory('GroupModel', ['UserModel', function(UserModel) {
  var GroupModel = {};
  GroupModel.groups = {}; //ID to groups
  GroupModel.fetchedGroups = false;

  // update GroupModel.groups with this "group" from the model. Note that the field names
  // are slightly different between the frontend and backend models,
  // so always go through this function to update groups.
  GroupModel.updateGroup = function(group) {
    console.log(group.dateCreated, formatDate(group.dateCreated));
    GroupModel.groups[group.id] = new Group(group.id, group.self, group.name, group.description, 
                                              group.creator, formatDate(group.dateCreated), group.users);
    for(var index in group.users) {
      UserModel.updateUser(group.users[index]);
    }
  }

  // Ask the given models to get their data
  // from the server again
  GroupModel.refreshAll = function(model) {
    if(model instanceof Array) {
      for(i in model) {
        model[i].refresh(function() {});
      }
    } else {
      model.refresh(function() {});
    }
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

  GroupModel.getGroups = function(callback) {
    // We really only need to ask the server for all groups
    // the first time, so get it only if we need to.
    if(!GroupModel.fetchedGroups) {
      $.get("/view_groups")
      .success(function(data, status) {
        for(var i = 0; i < data.length; i++) {
          GroupModel.updateGroup(data[i]);
        }
        GroupModel.fetchedGroups = true;

        // Return the groups and note that this is an asynchronous callback
        callback(GroupModel.groups, true, null);
      })
      .fail(function(xhr, textStatus, error) {
        callback(null, null, JSON.parse(xhr.responseText));
      });
    } else {
      // Otherwise, just return all the groups, 
      // and note that this is not asynchronous
      callback(GroupModel.groups, false, null);
    }
  }

  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise.
  //Note: The "members" array does not need to contain the creator. The creator
  //of a group will be placed in the group by default.
  GroupModel.createGroup = function(name, description, members, callback) {
    function extractIds(userList) {
      var userIds = [];
      userList.forEach(function(user){
        userIds.push(user.id);
      });
      return userIds;
    }

    $.post("/create_group",
    {
      "group[name]": name,
      "group[description]": description,
      "add[members]": extractIds(members)
    })
    .success(function(data, status) {
      GroupModel.updateGroup(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise.
  //Note: The "members" array does not need to contain the creator. The creator
  //of a group will be placed in the group by default.
  GroupModel.addMember = function(group, email, callback) {
    if(!(email && group)) {
      callback("Missing fields");
    }

    $.post("/add_to_group",
    {
      "invite[gid]" : group,
      "invite[email]": email
    })
    .success(function(data, status) {
      GroupModel.groups[group].members = data;
      for(var i = 0; i < data.length; i++) {
        UserModel.updateUser(data[i]);
      }
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback("User not found: " + email);
    });
  };

  //Update any or all of these fields for the group with the groupID (which is required).
  //If a field is null, that field is not updated. If the groupID is not found,
  //indicates failure...
  GroupModel.editGroup = function(groupID, name, description, callback) {
    var old = GroupModel.groups[groupID];

    if(!(groupID && name && description)) {
      callback("Name or description cannot be empty");
    }

    // If nothing changed, do nothing
    if(old.name == name && old.description == description) {
      callback();
    }

    $.post("/edit_group",
    {
      "editgroup[id]": groupID,
      "editgroup[name]": name,
      "editgroup[description]": description
    })
    .success(function(data, status) {
      GroupModel.updateGroup(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // Remove the current user from a group. On error, calls callback with error;
  // otherwise just calls callback with no params.
  GroupModel.leaveGroup = function(groupID, callback, TaskModel, BillModel) {
    if(!groupID) {
      callback("No group selected");
      return;
    }

    $.post("/leave_group",
    {
      "leave[id]": groupID
    })
    .success(function(data, status) {
      delete GroupModel.groups[groupID];
      GroupModel.refreshAll([TaskModel, BillModel]);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  }

  return GroupModel;
}]);
