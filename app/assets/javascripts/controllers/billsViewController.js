/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", "UserModel", "GroupModel", 
  function($scope, BillModel, UserModel, GroupModel) {
  $scope.activeBillTab='bill_selected_you_owe';
  $scope.newBillTitle = "";
  $scope.newBillDescription = "";
  $scope.newBillDateDue = "";
  $scope.newBillTotal = "";
  $scope.newBillGroup = "";
  $scope.newBillMembers = "";

  $scope.groupsList = {};
  $scope.currentMembers = {};

  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
    }
  });

  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('changed');
  });

  $scope.$watch('newBillGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = $scope.newBillGroup.members;
  });
  
  $scope.notSelf = function(user){
    console.log("comparing ",user, " and ",UserModel.me);
    return user.id != UserModel.me;
  }

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
  
  var buildAmountMap = function(members){
    var map = {};

    for(var i in members){
      if(members[i].chked){
        map[members[i].id] = members[i].amount;
      }
    }

    // the user who creates the bill owe nothing to himself
    map[UserModel.me] = 0;

    return map;
  }

  $scope.createBill = function(e) {
    // dummy bill data:
    // var groupID = 57;
    // var title = "bill_title 3";
    // var description = "bill_description! 3";
    // var dateDue = new Date();
    // var total = 30;
    // var membersAmountMap = {1:4, 3:6, 4:20};

    var groupID = $scope.newBillGroup.id;
    var title = $scope.newBillTitle;
    var description = $scope.newBillDescription;
    var dateDue = $scope.newBillDateDue;
    var total = $scope.newBillTotal;
    var membersAmountMap = buildAmountMap($scope.currentMembers);

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
    {person:'Member1', amount: 12, why: 'Bought Lunch'},
    {person:'Member1', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member3', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member1', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member2', amount: 23, why: 'Bought Lunch'},
    {person:'Member1', amount: 8, why: 'Bought Dinner'}];
    
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
  
  $scope.billsOweYouMap = [];

  $scope.billsOweYou = [
    {person:'Member1', amount: 12, why: 'Bought Lunch'},
    {person:'Member2', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member3', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member4', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member2', amount: 23, why: 'Bought Lunch'},
    {person:'Member1', amount: 8, why: 'Bought Dinner'}];
    
  $(function () {
    $.each($scope.billsOweYou, function(bill) {
      var found = false;
      var bill = this;
      $.each($scope.billsOweYouMap, function(member) {
        if (this.person == bill.person) {
          this.amount += bill.amount;
          this.bills.push({amt: bill.amount, why: bill.why});
          found = true;
          return false;
        }
      });
      if (!found) {
        $scope.billsOweYouMap.push({person: bill.person, amount: bill.amount, bills: [{amt: bill.amount, why: bill.why}]});
      }
    });
  });

  $scope.openPop = function (p, n) {
    if ($('#' + p + n).is(':visible')) {
      $('#' + p + n).hide();
    }
    else {
      $('#' + p + n).show();
    }
    $('.bill-pop').not('#' + p + n).hide();
  }
  
  $scope.closePop = function (e) {
    $('.bill-pop').hide();
  };

  $('#openBtn').click(function(){
    $('#myModal').modal({show:true})
  });

}]);

