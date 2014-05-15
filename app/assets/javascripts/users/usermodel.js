
/**
TeamPlayer -- 2014

This file holds the client side model that houses information
about all users the client is in a group with.

It also provides the login and create account interface to the backend.
*/

//This is a User object. It holds all the information
//a client needs to know about a user
// --id (unique identifier for this user)
// --user name
// --first name
// --last name
var User = function(id, uname, fname, lname) {
  this.id = id,
  this.uname = uname,
  this.fname = fname,
  this.lname = lname
};

//This is the UserModel for the application. It houses
//the information about all users this user is in a group with,
//including the data for the current user.
angular.module("myapp").factory('UserModel', function() {
  var UserModel = {};
  UserModel.me = -1;
  UserModel.users = {}; // ID to users
  UserModel.fetchedUser = false;


  UserModel.fetchUserFromServer = function(callback) {
    // We really only need to ask the server for all groups
    // the first time, so return if we already have.
    if(UserModel.fetchedUser) {
      return;
    }

    $.get("/user")
    .success(function(data, status) {
      for(var i = 0; i < data.length; i++) {
        UserModel.updateMe(data);
      }
      callback();
      UserModel.fetchedUser = true;
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  }


  // Save the user information in the UserModel, or return false
  // if any fields in user are not set, or id is negative
  UserModel.updateUser = function(user) {
    if(!(user && user.id && user.username && user.firstname && user.lastname && user.id > 0)) {
      return false;
    }

    UserModel.users[user.id] = new User(user.id, user.username,
                                        user.firstname, user.lastname);
    return true;
  }

  //Update the current user info to the information contained
  //in data
  function updateMe(data) {
    UserModel.me = data.id;
    UserModel.updateUser(data);
  };

  // Log the current user out.
  // On success, set the 'me' variable to negative so that it is not a valid user.
  // On failure, an error text message is used to call back
  UserModel.logout = function(callback) {
    $.ajax({
      url: '/sign_out',
      type: 'DELETE',
    })
    .success(function(data, status) {
      // reset 'me' to negative
      UserModel.me = -1;
      callback();
      window.location = "./";
    })
    .fail(function(xhr, textStatus, error) {
      var res = JSON.parse(xhr.responseText);
      callback(res["errors"]);
    });
  };

  //Try to log the current user in with the given username and password.
  //On success, no arguments are provided to callback, but on failure,
  //a text message describing the failure is the only parameter
  UserModel.login = function(uname, psswd, callback) {
   if(!(uname && psswd)) {
   return "MISSING_PARAM";
   }

    $.post("/sign_in",
    {
      "user[username]": uname,
      "user[password]": psswd
    })
    .success(function(data, status) {
      updateMe(data);
      callback();
      window.location = "./home";
    })
    .fail(function(xhr, textStatus, error) {
      var res = JSON.parse(xhr.responseText);
      callback(res["errors"]);
    });
  };

  //Try to create a new user account with the given parameters.
  //On success, the user is logged in, and the callback function
  //is called with no parameters. On failed, it will be called
  //with a string text message describing the failure. Failures can happen if:
  // --missing any parameters
  // --user name is taken
  // --email is already used
  // --passwords don't match
  UserModel.createAccount = function(fname, lname, uname, email,
                                      psswd_one, psswd_two, callback) {
    if(!(fname && lname && uname && email && psswd_one && psswd_two)) {
      return "MISSING_PARAM";
    }


    $.post("/create_user",
    {
      "user[firstname]": fname,
      "user[lastname]": lname,
      "user[username]": uname,
      "user[email]": email,
      "user[password]": psswd_one,
      "user[password_confirmation]": psswd_two
    })
    .success(function(data, status) {
      updateMe(data);
      callback();
      window.location = "./home";
    })
    .fail(function(xhr, textStatus, error) {
      var res = JSON.parse(xhr.responseText);
      callback(res["errors"]);
    });
  };

  //Lookup a users's information (including whether they exist)
  //by email. It calls the callback function with two parameters
  // --user: the user object (if there is a user with the given email)
  // --error: a descriptive error message if applicable
  UserModel.getUserByEmail = function(email, callback) {
    if(!email) {
      return;
    }

    //Ask the backend for the user information
    $.post("/find_user_email",
    {
      "find[email]": email
    })
    .success(function(data, status) {
      callback(new User(data.id, data.username, data.firstname, data.lastname));
    })
    .fail(function(xhr, textStatus, error) {
      callback(null, "User not found");
    });
  };

  //Get the information for the user with the given id,
  //or "undefined" if there is none
  UserModel.get = function(id) {
    return UserModel.users[id];
  };

  return UserModel;
});
