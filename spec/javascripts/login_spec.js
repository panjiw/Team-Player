angular.module('myapp');

describe("Login Tests", function() {
  var $scope, $location, $rootScope, createController;
  beforeEach(inject(function($injector) {
      $location = $injector.get('$location');
      $rootScope = $injector.get('$rootScope');
      $scope = $rootScope.$new();

      var $controller = $injector.get('$controller');

      createController = function() {
          return $controller('loginViewController', {
              '$scope': $scope
          });
      };
  }));

  it("Dummy test", function() {
    expect(true).toBe(true);
  });

  it("check login missing params fails", function() {
    console.log($scope);
    expect($scope.message).toBe("Hello, world");
  });
});
