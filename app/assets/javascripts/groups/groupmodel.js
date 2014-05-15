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
  GroupModel.fetchedGroups = false;

  GroupModel.updateGroup = function(group) {
    GroupModel.groups[group.id] = new Group(group.id, group.self, group.name, group.description, 
                                              group.creator, new Date(group.dateCreated), group.users);
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
    console.log("Trying to get groups...");
    if(!GroupModel.fetchedGroups) {
      $.get("/view_groups")
      .success(function(data, status) {
        for(var i = 0; i < data.length; i++) {
          GroupModel.updateGroup(data[i]);
          for(member in data[i].users) {
            UserModel.updateUser(member);
            console.log("---users updated--,",UserModel.users, member);
          }
          console.log("group data i ", data[i]);

        }
        GroupModel.fetchedGroups = true;
        console.log("model success");

        // Return the groups and note that this is an asynchronous callback
        callback(GroupModel.groups, true, null);
      })
      .fail(function(xhr, textStatus, error) {
        console.log("error:");
        console.log(xhr.responseText);
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
    console.log("mems:");
    console.log(members);
    console.log("ids:");
    console.log(extractIds(members));

    // create a group
    // current_user will set as creator, no need to send creator
    // current_user will be added to the group as member
    $.post("/create_group",
    {
      "group[name]": name,
      "group[description]": description,
      "add[members]": extractIds(members)
    })
    .success(function(data, status) {
      console.log("Success: " , data);
      GroupModel.updateGroup(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("group create error: "+error);
      callback("Error: " + JSON.parse(xhr.responseText));
    });
  };

  //Create and return a group with the given parameters. This updates to the database, or returns
  //error codes otherwise.
  //Note: The "members" array does not need to contain the creator. The creator
  //of a group will be placed in the group by default.
  GroupModel.addMember = function(group, email, callback) {
    if(!(email && group)) {
      return;
    }

    console.log("Trying to add member " + email + " to group: " + group);

    $.post("/add_to_group",
    {
      "invite[gid]" : group,
      "invite[email]": email
    })
    .success(function(data, status) {
      console.log("Success. New member list", data);
      GroupModel.groups[group].members = data;
      for(var i = 0; i < data.length; i++) {
        UserModel.updateUser(data[i]);
      }
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("Failed");
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

  return GroupModel;
}]);
