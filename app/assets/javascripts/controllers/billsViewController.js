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
  };

  var activeEditBill = -1;
  function initEditBillData(bill){
    // reset if no bill is passed in
    if(!bill){
      activeEditBill = -1;
      return;
    }
    if (activeEditBill != bill.id){
      $scope.editBillTitle = bill.title;
      $scope.editBillDescription = bill.description;

      /** set the date; somehow bill.dateDue is returning and object like 
          {0:2, 1:0, 2:1,3:4,5:-,6:0,7:5,8:-,9:1,10:4} for 2014-05-14, so need to parse it
          weirdly with indexing **/
      var dateObj = $.extend(true, {}, bill.dateDue);
      if (dateObj){
        var year = parseInt(""+dateObj[0] + dateObj[1] + dateObj[2] + dateObj[3]);
        var month = parseInt(""+dateObj[5] + dateObj[6]);
        month -=1;
        var day = parseInt(""+dateObj[8] + dateObj[9]);

        $scope.editBillDateDue = new Date(year,month,day);
      } else {
        $scope.editBillDateDue = "";
      }
      
      

      console.log("date due",$scope.editBillDateDue);
      if ($scope.editBillDateDue == ""){
        $.datepicker._clearDate('#bill_edit_datepicker');
      } else {
        $('#bill_edit_datepicker').datepicker("setDate", $scope.editBillDateDue);
      }

      /** end set date **/
      
      $scope.editBillGroup = $.extend(true, {}, GroupModel.groups[bill.group]);

      $scope.editBillTotal = BillModel.deriveTotal(bill);
      
      $scope.currentEditMembers = $.extend(true, {}, GroupModel.groups[bill.group].members);

      for (var id in bill.membersAmountMap){
        for (var index in $scope.currentEditMembers){
          if($scope.currentEditMembers[index].id == id){
            $scope.currentEditMembers[index].chked = true;
            $scope.currentEditMembers[index].amount = bill.membersAmountMap[id].due;
          }
        }
      }


      activeEditBill = bill.id;
    }

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
      if(bills[i].creator == UserModel.me){
        for(var j in bills[i].membersAmountMap){
          console.log("creater is me, bills[i]: ",bills[i]);
          if (j != UserModel.me){
            console.log("users,",UserModel.users);
            $scope.billsOweYou.push({
              person: UserModel.users[j].firstname, 
              amount: bills[i].membersAmountMap[j].due, 
              why: bills[i].title,
              id: bills[i].id,
              desc: bills[i].description,
              due: bills[i].dateDue
            });
          }
        }
        
      } else {
        for(var j in bills[i].membersAmountMap){
          console.log("creater is not me, bills[i]: ",bills[i]);
          if (j == UserModel.me){
            $scope.billsYouOwe.push({
              person: UserModel.users[bills[i].creator].firstname, 
              amount: bills[i].membersAmountMap[j].due, 
              why: bills[i].title,
              id: bills[i].id,
              desc: bills[i].description,
              due: bills[i].dateDue
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
    return map;
  }

  // create a bill from user input
  $scope.createBill = function(e) {

    var groupID = $scope.newBillGroup.id;
    var title = $scope.newBillTitle;
    var description = $scope.newBillDescription;
    var dateDue = $("#bill_datepicker").datepicker( 'getDate' );
    var total = $scope.newBillTotal;
    var makeMembersAmountMap = buildAmountMap($scope.currentMembers);

    console.log("makeMembersAmountMap", makeMembersAmountMap);

    // first perform an empty field check
    if(!($scope.newBillGroup && $scope.newBillTitle && $scope.newBillTotal > 0
      && $scope.newBillDescription && Object.getOwnPropertyNames(makeMembersAmountMap).length > 0)) {
      e.preventDefault();

      if (!$scope.newBillGroup)
        toastr.error("Group not selected");
      if (!$scope.newBillTitle)
        toastr.error("Bill Name required");
      if (!($scope.newBillTotal) > 0)
        toastr.error("Bill total needs to be more than 0");
      if (!$scope.newBillDescription)
        toastr.error("Bill Description required");
      if (!(Object.getOwnPropertyNames(makeMembersAmountMap).length > 0))
        toastr.error("Member not selected");

      return;
    }

    BillModel.createBill(groupID, title, description, dateDue, total, makeMembersAmountMap,
      function(error){
      if(error){
        for (var index in error){
          toastr.error(error[index]);  
        }
      } else{
        $scope.$apply(function(){
          buildBills();
          initNewBillData();
        });
        toastr.success("Bill Created!");
        $('#billModal').modal('hide');

      }

    });

    
  };

  $scope.editBill = function(e) {

    var groupID = $scope.editBillGroup.id;
    var title = $scope.editBillTitle;
    var description = $scope.editBillDescription;
    var dateDue = $("#bill_edit_datepicker").datepicker( 'getDate' );
    var total = $scope.editBillTotal;
    var makeMembersAmountMap = buildAmountMap($scope.currentEditMembers);

    console.log("membersAmountMap", makeMembersAmountMap);

    // first perform an empty field check
    if(!($scope.editBillGroup && $scope.editBillTitle && $scope.editBillTotal > 0
      && $scope.editBillDescription && Object.getOwnPropertyNames(makeMembersAmountMap).length > 0)) {
      e.preventDefault();

      if (!$scope.editBillGroup)
        toastr.error("Group not selected");
      if (!$scope.editBillTitle)
        toastr.error("Bill Name required");
      if (!($scope.editBillTotal) > 0)
        toastr.error("Bill total needs to be more than 0");
      if (!$scope.editBillDescription)
        toastr.error("Bill Description required");
      if (!(Object.getOwnPropertyNames(makeMembersAmountMap).length > 0))
        toastr.error("Member not selected");

      return;
    }

    BillModel.editBill(activeEditBill, groupID, title, description, dateDue, total, makeMembersAmountMap,
      function(error){
      if(error){
        for (var index in error){
          toastr.error(error[index]);  
        }
      } else{
        $scope.$apply(function(){
          buildBills();
          initEditBillData();
        });
        toastr.success("Bill Edited!");
        $('#billEditModal').modal('hide');
      }

    });
  };



  $scope.showEditBill = function(e, billID){
    initEditBillData(BillModel.bills[billID]);
    $('#billEditModal').modal({show:true});
  };
    
  // Fills in billsYouOweMap from billsYouOwe
  function buildBillsMapYouOwe() {
    $.each($scope.billsYouOwe, function(bill) {
      var found = false;
      var bill = this;
      $.each($scope.billsYouOweMap, function(member) {
        if (this.person == bill.person) {
          this.amount += bill.amount;
          if (bill.due != null) {
            this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: bill.due});
          }
          else {
            this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: "No Date"});
          }
          found = true;
          return false;
        }
      });
      if (!found) {
        if (bill.due != null) {
          $scope.billsYouOweMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
            why: bill.why, desc: bill.desc, due: bill.due}]});
        }
        else {
          $scope.billsYouOweMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
            why: bill.why, desc: bill.desc, due: "No Date"}]});  
        }
      }
    });
  }
    
  // Fills in billsOweYouMap from billsOweYou
  function buildBillsMapOweYou() {
    console.log("building bills map");
    $.each($scope.billsOweYou, function(bill) {
      var found = false;
      var bill = this;
      $.each($scope.billsOweYouMap, function(member) {
        if (this.person == bill.person) {
          this.amount += bill.amount;
          if (bill.due != null) {
            this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: bill.due});
          }
          else {
            this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: "No Date"});
          }
          found = true;
          return false;
        }
      });
      if (!found) {
        if (bill.due != null) {
          $scope.billsOweYouMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
            why: bill.why, desc: bill.desc, due: bill.due}]});
        }
        else {
          $scope.billsOweYouMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
            why: bill.why, desc: bill.desc, due: "No Date"}]});  
        }
      }
    });
  }

  function buildBillsMap(){
    buildBillsMapOweYou();
    buildBillsMapYouOwe();
  }

  // function for datepicker to popup
  $(function() {$( "#bill_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});
  $(function() {$( "#bill_edit_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});

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
    $(".bills-selected").popover();
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
      var id = str.substr(str.indexOf(' ')+1);
      if (this.checked) {
        $.each($scope.billsYouOweMap, function(member) {
          if (this.person == p) {
            this.amount -= value;
            var list = this.bills
            $.each(list, function(i, bill) {
              if (this.id == id) {
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
    $('#billModal').modal({show:true})
  });

  $scope.openBillHelpModal = function(e){
    $('#billHelpModal').modal({show:true})
  };

  $scope.billNext = function(pageNum) {
    $('#'+'billHelp'+pageNum).hide();
    $('#'+ 'billHelp'+(parseInt(pageNum)+1)).show();
  }

  $scope.billBack = function(pageNum) {
    $('#'+'billHelp'+pageNum).hide();
    $('#'+'billHelp'+(parseInt(pageNum)-1)).show();
  }
  
  $scope.splitEvenly = function(mem) {
    if ($("#bill-split-evenly-checkbox").is(":checked")) {
      var total = $scope.newBillTotal;
      var list = $(".bill-members-check:checked");
      var value = total / list.size();
      value = Math.round(value * 100) / 100;
      $.each($scope.currentMembers, function() {
        if (this.chked) {
          this.amount = value;
        }
      });
      if (mem) {
        mem.amount = value;
      }
    }
  }
  
  $scope.disableBillInputs = function() {
    if ($("#bill-split-evenly-checkbox").is(":checked")) {
      $(".bill-members-amount").prop('disabled', true);
    }
    else {
      $(".bill-members-amount").prop('disabled', false);
    }
  }

}]);

