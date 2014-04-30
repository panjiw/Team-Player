var User = {
	uname: "",
	fname: "",
	lname: ""
};

angular.module("myapp").factory('UserModel', function() {
  var UserModel = {}
  var me = new User();
  

  UserModel.login = function(uname, psswd) {
  	//TODO ajax
  	if(!(uname && psswd)) {
  		//TODO error code
  		return "ERROR_CODE";
  	}

  	//TODO ajax
  	//Dummy User:
  	me.uname = "go_dawgs";
  	me.fname = "Team";
  	me.lname = "Player"
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