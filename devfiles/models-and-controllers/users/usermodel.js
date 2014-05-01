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

  UserModel.createAccount = function(fname, lname, uname, psswd_one, psswd_two) {
  	if(!(fname && lname && uname && pswd_one && pswd_two)) {
      
      //TODO error code
      return "ERROR_CODE";
    } else if(pswd_one != pswd_two) {
    	return "PASSWORD_FAIL";
    }

    //TODO ajax
  }

  return UserModel;
});
