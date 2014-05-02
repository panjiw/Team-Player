var User = function() {
  this.id = 0,
	this.uname = "",
	this.fname = "",
	this.lname = ""
};

angular.module("myapp").factory('UserModel', function() {
  var UserModel = {}
  UserModel.me = new User();
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


  UserModel.login = function(uname, psswd) {
  	//TODO ajax
  	if(!(uname && psswd)) {
  		//TODO error code
  		return "ERROR_CODE";
  	}

  	//TODO ajax
  	//Dummy User:
    UserModel.me.id = 0;
  	UserModel.me.uname = "go_dawgs";
  	UserModel.me.fname = "Team";
  	UserModel.me.lname = "Player";
  }

  UserModel.createAccount = function(fname, lname, uname, email, psswd_one, psswd_two) {
  	if(!(fname && lname && uname && email && pswd_one && pswd_two)) {
      return "MISSING_PARAM";
    }
    $.post("http://localhost:3000/create_user",
    {
      "user[firstname]": fname,
      "user[lastname]": lname,
      "user[username]": uname,
      "user[email]": email,
      "user[password]": psswd_one,
      "user[password_confirmation]": psswd_two,
      "commit": "Create+my+account"
    },
    function(data, status){
      alert("Data: " + data + "\nStatus: " + status);
    });
  }

  return UserModel;
});
