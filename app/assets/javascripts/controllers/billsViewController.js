/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", function($scope, BillModel) {
	$scope.activeBillTab='bill_selected_you_owe';
  $scope.newBillInfo = {
    title: "",
    description: "",
    total: ""

  };

  $scope.getBillFromModel = function(e) {
    BillModel.getBillFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
      }
    });
  }

  $scope.createBill = function(e) {
    // dummy bill data:
    var groupID = 2;
    var title = "bill_title 3";
    var description = "bill_description! 3";
    var dateDue = new Date();
    var total = 30;
    var membersAmountMap = {1:10, 2:20};
    BillModel.createBill(groupID, title, description, dateDue, total, membersAmountMap,
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
      }
    });
  };

  $(function () { $("[data-toggle='popover']").popover({ html : true }); });
  $('.btn').on('click', function (e) {
    $('.btn').on('click', function (e) {
        $('.btn').not(this).popover('hide');
    });
  });
  $('a').on('click', function (e) {
      $('.btn').popover('hide');
  });

  $('#openBtn').click(function(){
  	$('#myModal').modal({show:true})
  });

}]);
