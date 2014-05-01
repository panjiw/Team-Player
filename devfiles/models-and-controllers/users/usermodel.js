var User = function() {
  this.id = 0,
	this.uname = "",
	this.fname = "",
	this.lname = ""
};

angular.module("myapp").factory('UserModel', function() {
  var UserModel = {}
  UserModel.me = new User();
  

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
