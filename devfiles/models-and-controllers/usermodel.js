angular.module("myapp").factory('UserModel', function() {
  var UserModel = {}
  UserModel.id = 0;
  UserModel.uname = "";
  UserModel.fname = "";
  UserModel.lname = "";

  UserModel.login = function(uname, psswd) {
  	//TODO
  }

  return UserModel;
});