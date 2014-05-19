/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", "UserModel", "GroupModel", 
  function($scope, BillModel, UserModel, GroupModel) {

  function initNewBillData(){
    $scope.newBillTitle = "";
    $scope.newBillDescription = "";
    $scope.newBillDateDue = "";
    $scope.newBillTotal = "";
    $scope.newBillGroup = "";
    $scope.newBillMembers = "";
  };

  $scope.activeBillTab='bill_selected_you_owe';
  
  initNewBillData();
  $scope.groupsList = {};
  $scope.currentMembers = {};

  getBillFromModel = function(e) {
    BillModel.getBillFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        $scope.$apply(function(){
          buildBills();
        });
      }
    });
  };

  // getBillFromModel after groups and users are loaded
  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
      getBillFromModel();
    }
  });

  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('group list in bill changed');
  });

  $scope.$watch('newBillGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = $scope.newBillGroup.members;
  });
  
  $scope.notSelf = function(user){
    console.log("comparing ",user, " and ",UserModel.me);
    return user.id != UserModel.me;
  }
  
  function buildBills(){
    buildBillsList();
    buildBillsMap();
  }

  $scope.$watch('billsYouOweMap', function(newVal, oldVal){
    console.log('billsYouOweMap changed');
  },true);

  $scope.$watch('billsYouOwe', function(newVal, oldVal){
    console.log('billsYouOwe changed');
  },true);

  $scope.$watch('billsOweYouMap', function(newVal, oldVal){
    console.log('billsOweYouMap changed');
  },true);

  $scope.$watch('billsOweYou', function(newVal, oldVal){
    console.log('billsOweYou changed');
  },true);

  //{person:'Member1', amount: 12, why: 'Bought Lunch'}

  function buildBillsList(){
    $scope.billsYouOwe = [];
    $scope.billsOweYou = [];
    $scope.billsOweYouMap =[];
    $scope.billsYouOweMap =[];

    var bills = BillModel.bills;
    console.log("bills is ", bills);
    for(var i in bills){
      if(bills[i].event.creator == UserModel.me){
        for(var j in bills[i].membersAmountMap){
          console.log("creater is me, bills[i]: ",bills[i]);
          if (j != UserModel.me){
            console.log("users,",UserModel.users);
            $scope.billsOweYou.push({
              person: UserModel.users[j].fname, 
              amount: bills[i].membersAmountMap[j].due, 
              why: bills[i].event.title
            });
          }
        }
        
      } else {
        for(var j in bills[i].membersAmountMap){
          console.log("creater is not me, bills[i]: ",bills[i]);
          if (j == UserModel.me){
            $scope.billsYouOwe.push({
              person: UserModel.users[bills[i].event.creator].fname, 
              amount: bills[i].membersAmountMap[j].due, 
              why: bills[i].event.title
            });
          }
        }

      }
    }
  }


  
  var buildAmountMap = function(members){
    var map = {};

    for(var i in members){
      if(members[i].chked){
        map[members[i].id] = members[i].amount;
      }
    }



    console.log("adding ", UserModel.me, " to ",map);

    return map;
  }

  // create a bill from user input
  $scope.createBill = function(e) {

    var groupID = $scope.newBillGroup.id;
    var title = $scope.newBillTitle;
    var description = $scope.newBillDescription;
    var dateDue = $scope.newBillDateDue;
    var total = $scope.newBillTotal;
    var membersAmountMap = buildAmountMap($scope.currentMembers);

    console.log("membersAmountMap", membersAmountMap);

    // first perform an empty field check
    if(!($scope.newBillGroup && $scope.newBillTitle && $scope.newBillTotal > 0
      && $scope.newBillDescription && Object.getOwnPropertyNames(membersAmountMap).length > 0)) {
      e.preventDefault();
      toastr.error("Empty fields");
      return;
    }

    BillModel.createBill(groupID, title, description, dateDue, total, membersAmountMap,
      function(error){
      if(error){
        //TODO
      } else{
        $scope.$apply(function(){
          buildBills();
        });
        toastr.success("bill created!");
      }
    });

    initNewBillData();
  };

  // Map for the total you owe each member
  $scope.billsYouOweMap = [];

  // Each bill you owe
  $scope.billsYouOwe = [
    {person:'Member1', amount: 12, why: 'Bought Lunch'},
    {person:'Member1', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member2', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member1', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member3', amount: 23, why: 'Bought Lunch'},
    {person:'Member1', amount: 8, why: 'Bought Dinner'}];
    
  // Fills in billsYouOweMap from billsYouOwe
  function buildBillsMapYouOwe() {
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
  }
  
  //Map for the total each member owes you
  $scope.billsOweYouMap = [];

  // Each bill a member owes you
  $scope.billsOweYou = [
    {person:'Member5', amount: 12, why: 'Bought Lunch'},
    {person:'Member6', amount: 68, why: 'Paid Electric Bill'},
    {person:'Member7', amount: 32, why: 'Bought Toilet Paper'},
    {person:'Member8', amount: 44, why: 'Paid Internet Bill'},
    {person:'Member6', amount: 23, why: 'Bought Lunch'},
    {person:'Member5', amount: 8, why: 'Bought Dinner'}];
    
  // Fills in billsOweYouMap from billsOweYou
  function buildBillsMapOweYou() {
    console.log("building bills map");
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
  }

  function buildBillsMap(){
    buildBillsMapOweYou();
    buildBillsMapYouOwe();
  }

  // Function called when Select Bills or View Bills is clicked. Toggles popover
  $scope.openPop = function (e, p, n) {
    if ($('#' + p + n).is(':visible')) {
      $('#' + p + n).hide();
      $(e.delegateTarget).css("border", "1px solid white");
    }
    else {
      $('#' + p + n).show();
      $(e.delegateTarget).css("border", "1px solid green");
    }
    $('.bill-pop').not('#' + p + n).hide();
    $('.bill').not($(e.delegateTarget)).css("border", "1px solid white");
  }
  
  // Function when checkbox is clicked. Updates displayed total
  $scope.updateTotal = function(p) {
    var total = 0;
    $('#' + p + 1 + " input:checkbox").each(function () {
      var str = $(this).val();
      var value = str.substr(0,str.indexOf(' '));
      total += (this.checked ? parseInt(value) : 0);
    });
    $('#' + p + 1 + " .bill-pop-total").html('Total: $' + total);
  }
  
  // Function called when anything is clicked in bills page that should close popover
  $scope.closePop = function () {
    $('.bill-pop').hide();
    $('.bill').css("border", "1px solid white");
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
            $('#' + p + 1 + " .bill-pop-total").html('Total: $0');
            return false;
          }
        });
      }
    });
    $('.bill-pop').hide();
    $('.bill').css("border", "1px solid white");
  }

  $('#openBtn').click(function(){
    $('#myModal').modal({show:true})
  });

}]);

