var myApp = angular.module('myapp')
myApp.controller("BillController", ["$scope", "BillModel", function($scope, BillModel) {
	$scope.bills = BillModel.getBills();

	$scope.addBill = function(e) {
		//TODO
	};

	$scope.editBill = function(e) {
		//TODO
	};

	$scope.paidBy = function(e) {
		//TODO
	};
}]);