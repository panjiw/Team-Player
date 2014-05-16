describe("Login (Integration) Tests", function() {
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
});
