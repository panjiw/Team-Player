/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", function($scope, BillModel) {
	$scope.activeBillTab='bill_selected_you_owe';

  $scope.createBill = function(e) {
    // dummy bill data:
    var groupID = 57;
    var title = "bill_title";
    var description = "bill_description!";
    var dateDue = new Date();
    var total = 100;
    var membersAmountMap = {3:25, 4:75};
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
