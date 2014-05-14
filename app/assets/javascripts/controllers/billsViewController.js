/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", "GroupModel", 
  function($scope, BillModel, GroupModel) {
  $scope.activeBillTab='bill_selected_you_owe';
  $scope.newBillTitle = "";
  $scope.newBillDescription = "";
  $scope.newBillDateDue = "";
  $scope.newBillTotal = "";
  $scope.newBillGroup = "";
  $scope.newBillMembers = "";

  $scope.groupsList = {};

  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
    }
  });

  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('changed');
  });
  

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
    var groupID = 57;
    var title = "bill_title 3";
    var description = "bill_description! 3";
    var dateDue = new Date();
    var total = 30;
    var membersAmountMap = {1:4, 3:6, 4:20};
    BillModel.createBill(groupID, title, description, dateDue, total, membersAmountMap,
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
      }
    });
  };

  $scope.billsYouOweMap = [];

  $scope.billsYouOwe = [
    {person:'Member 1', amount: 12, why: 'Bought Lunch'},
    {person:'Member 1', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member 3', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member 1', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member 2', amount: 23, why: 'Bought Lunch'},
    {person:'Member 1', amount: 8, why: 'Bought Dinner'}];
    
  $(function () {
    $.each($scope.billsYouOwe, function(bill) {
      var found = false;
      var bill = this;
      $.each($scope.billsYouOweMap, function(member) {
        if (this.person == bill.person) {
          this.amount += bill.amount;
          this.bills.push({amt: bill.amount, why: bill.why});
          found = true;
          return false;
        }
      });
      if (!found) {
        $scope.billsYouOweMap.push({person: bill.person, amount: bill.amount, bills: [{amt: bill.amount, why: bill.why}]});
      }
    });
  });

  $(function () { $("[data-toggle='popover']").popover({ html : true }); });
  $scope.openPop = function (e) {
    $('.btn').on('click', function (e) {
        $('.btn').not(this).popover('hide');
    });
  };

  $('#openBtn').click(function(){
    $('#myModal').modal({show:true})
  });

}]);
