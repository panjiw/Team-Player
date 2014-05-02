var User = function() {
  this.id = 0,
	this.uname = "",
	this.fname = "",
	this.lname = ""
};

angular.module("myapp").factory('UserModel', function() {
  var UserModel = {}
  UserModel.me = 0;
  UserModel.users = {}; // ID to users
  // dummy users
  UserModel.users[0] = UserModel.me;
  UserModel.users[0].id = 0;
  UserModel.users[0].uname = "go_dawgs";
  UserModel.users[0].fname = "Team";
  UserModel.users[0].lname = "Player";

  UserModel.users[1] = new User();
  UserModel.users[1].id = 1;
  UserModel.users[1].uname = "fd_01";
  UserModel.users[1].fname = "friend";
  UserModel.users[1].lname = "Zone";

  function updateUser(data, status) {
    //TODO error codes, and updating
    alert("Data: " + data + "\nStatus: " + status);
  }


  UserModel.login = function(uname, psswd) {
  	if(!(uname && psswd)) {
  		return "MISSING_PARAM";
  	}

    $.post("http://localhost:3000/sign_in",
    {
      "user[username]": uname,
      "user[password]": psswd
    }, updateUser);

  	//Dummy User:
    UserModel.me.id = 0;
  	UserModel.me.uname = "go_dawgs";
  	UserModel.me.fname = "Team";
  	UserModel.me.lname = "Player";
  }

  UserModel.createAccount = function(fname, lname, uname, email, psswd_one, psswd_two) {
  	console.log("model!");
    if(!(fname && lname && uname && email && psswd_one && psswd_two)) {
      return "MISSING_PARAM";
    }


    $.post("http://localhost:3000/create_user",
    {
      "user[firstname]": fname,
      "user[lastname]": lname,
      "user[username]": uname,
      "user[email]": email,
      "user[password]": psswd_one,
      "user[password_confirmation]": psswd_two
    }, updateUser);
  }

  return UserModel;
});
