
/**
  TeamPlayer -- 2014

  This file holds the client side model that houses information
  about all users the client is in a group with.

  It also provides the login and create account interface to the backend.
*/

//This is a User object. It holds all the information
//a client needs to know about a user
//  --id (unique identifier for this user)
//  --user name
//  --first name
//  --last name
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
  UserModel.me = 0;
  UserModel.users = {}; // ID to users

  // dummy users
  UserModel.users[0] = new User(0, "go_dawgs", "Team", "Player");
  UserModel.users[1] = new User(1, "fd_01", "friend", "zone");

  //Update the current user info to the information contained
  //in data
  function updateUser(data, status) {
    UserModel.me = data.id;
    UserModel.users[UserModel.me] = new User(UserModel.me, data.username, 
                                              data.firstname, data.lastname);
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
      console.log("Logged out.");
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
      updateUser(data, status);
      console.log("Logged in as user: " + data);
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
  //  --missing any parameters
  //  --user name is taken
  //  --email is already used
  //  --passwords don't match
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
      updateUser(data, status);
      console.log("New User: " + data);
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
  //  --user: the user object (if there is a user with the given email)
  //  --error: a descriptive error message if applicable
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
      callback(new User(data.id, data.uname, data.fname, data.lname));
    })
    .fail(function(xhr, textStatus, error) {
      var res = JSON.parse(xhr.responseText);
      callback({}, res.errors);
    });
  };

  //Get the information for the user with the given id,
  //or "undefined" if there is none
  UserModel.get = function(id) {
    return UserModel[id];
  };

  return UserModel;
});
