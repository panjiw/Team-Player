describe("Bill Split Tests", function() {
  var $scope, ctrl, BillModel, member1, member2, member3;
  beforeEach(function() { 
    module("myapp");

    inject(function($rootScope, $controller) {
      $scope = $rootScope.$new();
      ctrl = $controller("billViewController", {"$scope": $scope});
    });

    inject(function(_BillModel_) {
      BillModel = _BillModel_;
      expect(BillModel).toBeDefined();
      
    });
    
    member1 = {amount: 1, chked: false, email: "a@a.com", 
      firstname: "a", id: "1", lastname: "a", username: "a"};
    member2 = {amount: 2, chked: false, email: "b@b.com", 
      firstname: "b", id: "2", lastname: "b", username: "b"};
    member3 = {amount: 3, chked: false, email: "c@c.com", 
      firstname: "c", id: "3", lastname: "c", username: "c"};
  });
  
  it("Testing split bills", function() {
    $scope.currentMembers = {1: member1, 2: member2, 3: member3};
    $scope.newBillTotal = 10;
    
    $scope.currentMembers.1.chked = true;
    $scope.splitEvenly(currentMembers.1, 1);
    expect($scope.currentMembers.1.amount).toBe(10);
    
    $scope.currentMembers.2.chked = true;
    $scope.splitEvenly(currentMembers.2, 1);
    expect($scope.currentMembers.1.amount).toBe(5);
    expect($scope.currentMembers.2.amount).toBe(5);
    
    $scope.currentMembers.3.chked = true;
    $scope.splitEvenly(currentMembers.3, 1);
    expect($scope.currentMembers.1.amount).toBe(3.33);
    expect($scope.currentMembers.2.amount).toBe(3.33);
    expect($scope.currentMembers.3.amount).toBe(3.33);
  });
  
});
