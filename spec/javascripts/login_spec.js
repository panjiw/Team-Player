describe("Login Tests", function() {
  var $scope, ctrl, UserModel;
  beforeEach(function() { 
    module("myapp");

    inject(function($rootScope, $controller) {
      $scope = $rootScope;
      ctrl = $controller("loginViewController", {"$scope": $scope});
    });

    inject(function(_UserModel_) {
      UserModel = _UserModel_;
    });
  });

  it("checks hello world", function() {
    expect($scope.message).toBe("Hello, world");
  });

  it("checks login", function() {
    expect(UserModel.me).toBe(0);
  });
});
