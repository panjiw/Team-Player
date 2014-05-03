angular.mock.module('myapp');

describe("Login Tests", function() {
  var $scope;

  beforeEach(angular.mock.inject(function($rootScope, $controller) {
    $scope = $rootScope.$new();
    $controller('loginViewController', {"$scope": $scope});
  }));

  it("Dummy test", angular.mock.inject(function() {
    expect(true).toBe(true);
  }));

  it("check login missing params fails", angular.mock.inject(function() {
    console.log($scope.message);
    expect($scope.message).toBe("Hello, world");
  }));
});
