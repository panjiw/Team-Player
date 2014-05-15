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

  // Map for the total you owe each member
  $scope.billsYouOweMap = [];

  // Each bill you owe
  $scope.billsYouOwe = [
    {person:'Member1', amount: 12, why: 'Bought Lunch'},
    {person:'Member1', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member3', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member1', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member2', amount: 23, why: 'Bought Lunch'},
    {person:'Member1', amount: 8, why: 'Bought Dinner'}];
    
  // Fills in billsYouOweMap from billsYouOwe
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
  
  //Map for the total each member owes you
  $scope.billsOweYouMap = [];

  // Each bill a member owes you
  $scope.billsOweYou = [
    {person:'Member1', amount: 12, why: 'Bought Lunch'},
    {person:'Member2', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member3', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member4', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member2', amount: 23, why: 'Bought Lunch'},
    {person:'Member1', amount: 8, why: 'Bought Dinner'}];
    
  // Fills in billsOweYouMap from billsOweYou
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

  // Function called when Select Bills or View Bills is clicked. Toggles popover
  $scope.openPop = function (p, n) {
    if ($('#' + p + n).is(':visible')) {
      $('#' + p + n).hide();
    }
    else {
      $('#' + p + n).show();
    }
    $('.bill-pop').not('#' + p + n).hide();
  }
  
  // Function when checkbox is clicked. Updates displayed total
  $scope.updateTotal = function(p) {
    var total = 0;
    $('#' + p + 1 + " input:checkbox").each(function () {
      var str = $(this).val();
      var value = str.substr(0,str.indexOf(' '));
      total += (this.checked ? parseInt(value) : 0);
    });
    $('#' + p + 1 + " .bill-pop-total").html('$' + total);
  }
  
  // Function called when anything is clicked in bills page that should close popover
  $scope.closePop = function () {
    $('.bill-pop').hide();
  };
  
  // Function called when pay button is pressed
  // Removes any checked bills and subtracts from total owed
  // If all bills are paid, removes the whole bill
  $scope.pay = function (p) {
    $('#' + p + 1 + " input:checkbox").each(function () {
      var str = $(this).val();
      var value = parseInt(str.substr(0,str.indexOf(' ')));
      var why = str.substr(str.indexOf(' ')+1);
      if (this.checked) {
        $.each($scope.billsYouOweMap, function(member) {
          if (this.person == p) {
            this.amount -= value;
            var list = this.bills
            $.each(list, function(i, bill) {
              if (this.amt == value && this.why == why) {
                list.splice(i, 1);
                if (list.length == 0) {
                  $.each($scope.billsYouOweMap, function(i, person) {
                    if (person.person == p) {
                      $scope.billsYouOweMap.splice(i, 1);
                      return false;
                    }
                  });
                }
                return false;
              }
            });
            $('#' + p + 1 + " .bill-pop-total").html('$0');
            return false;
          }
        });
      }
    });
    $('.bill-pop').hide();
  }

  $('#openBtn').click(function(){
    $('#myModal').modal({show:true})
  });

}]);

