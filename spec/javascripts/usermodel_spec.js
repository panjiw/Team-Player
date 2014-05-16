describe("User Model Tests", function() {
  var $scope, ctrl, UserModel;
  beforeEach(function() { 
    module("myapp");

    inject(function($rootScope, $controller) {
      $scope = $rootScope.$new();
      ctrl = $controller("loginViewController", {"$scope": $scope});
    });

    inject(function(_UserModel_) {
      UserModel = _UserModel_;
    });
  });

  describe("Test state before and after user information is inputted", function() {
    it("checks before login 'me' is -1", function() {
      expect(UserModel.me).toBe(-1);
    });

    it("checks before login 'users' is empty", function() {
      expect(Object.keys(UserModel.users).length).toBe(0);
    });

    it("checks that fetch user is false", function() {
      expect(UserModel.fetchedUser).toBe(false);
    });


  });

  describe("Test Update User", function() {
    it("checks that update user is a function", function() {
      expect(UserModel.updateUser).toBeDefined();
    });

    it("checks cannot update user", function() {
      expect(UserModel.updateUser(null)).toBe(false);
    });

    it("checks cannot update user with negative", function() {
      expect(UserModel.updateUser({id: -123, username: "test", firstname: "test", lastname: "test"})).toBe(false);
    });

    it("checks cannot update user with missing fields returns false", function() {
      expect(UserModel.updateUser({id: 234, username: "hello", firstname: "", lastname: "test"})).toBe(false);
    });

    it("checks update user normal case", function() {
      expect(UserModel.updateUser({id: 234, username: "test", firstname: "test", lastname: "test"})).toBe(true);
    });

    it("checks update user on a previously defined user works", function() {
      expect(UserModel.updateUser({id: 4, username: "test", firstname: "test", lastname: "test"})).toBe(true);
      expect(UserModel.updateUser({id: 4, username: "hello", firstname: "hello", lastname: "test"})).toBe(true);
    });
  });

  describe("Test get user", function() {
    it("checks that get user is a function", function() {
      expect(UserModel.get).toBeDefined();
    });

    it("checks get user not a user", function() {
      expect(UserModel.get(-123234)).not.toBeDefined();
    });

    it("checks get user normal case", function() {
      UserModel.updateUser({id: 234, username: "test", firstname: "test", lastname: "test"});
      expect(UserModel.users[234]).toBeDefined();

      console.log(UserModel.get(234).uname);

      var user = UserModel.get(234);
      expect(user).toBeDefined();
      expect(user.id).toBe(234);
      expect(user.uname).toBe("test");
      expect(user.fname).toBe("test");
      expect(user.lname).toBe("test");
    });

    it("check get user returns updated information", function() {
      UserModel.updateUser({id: 234, username: "test", firstname: "test", lastname: "test"});
      UserModel.updateUser({id: 234, username: "hello", firstname: "hello", lastname: "hello"});
      
      var user = UserModel.get(234);
      expect(user).toBeDefined();
      expect(user.id).toBe(234);
      expect(user.uname).toBe("hello");
      expect(user.fname).toBe("hello");
      expect(user.lname).toBe("hello");
    });

    it("ensures that you can update multiple users information", function() {
      UserModel.updateUser({id: 2, username: "test", firstname: "test", lastname: "test"});
      UserModel.updateUser({id: 1, username: "hello", firstname: "hello", lastname: "hello"});
      
      var user = UserModel.get(2);
      expect(user).toBeDefined();
      expect(user.id).toBe(2);
      expect(user.uname).toBe("test");
      expect(user.fname).toBe("test");
      expect(user.lname).toBe("test");

      user = UserModel.get(1);
      expect(user).toBeDefined();
      expect(user.id).toBe(1);
      expect(user.uname).toBe("hello");
      expect(user.fname).toBe("hello");
      expect(user.lname).toBe("hello");
    });
  });
});
