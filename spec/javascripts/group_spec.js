describe("Group Model Tests", function() {
  var $scope, ctrl, GroupModel;
  beforeEach(function() { 
    module("myapp");

    inject(function($rootScope, $controller) {
      $scope = $rootScope.$new();
      ctrl = $controller("groupsViewController", {"$scope": $scope});
    });

    inject(function(_GroupModel_) {
      GroupModel = _GroupModel_;
    });
  });
});