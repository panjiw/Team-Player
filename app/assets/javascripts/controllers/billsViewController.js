/*
 *  TeamPlayer -- 2014
 *
 *  This is the Angular Controller for the viewing bills page.
 *  It contains the logic for adding, editing, paying, and viewing bills
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", "UserModel", "GroupModel", 
  function($scope, BillModel, UserModel, GroupModel) {

  // Set $scope variables to default
  function initNewBillData(){
    $scope.newBillTitle = "";
    $scope.newBillDescription = "";
    $scope.newBillDateDue = "";
    $scope.newBillTotal = "";
    $scope.newBillGroup = "";
  };
  
  // Edits fields for edit modal when editing bills
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

      
      if (bill.dateDue){
        // make it a Date object
        $scope.editBillDateDue = bill.dateDue;
      } else {
        // if there is no date initially, make date empty
        $scope.editBillDateDue = "";
      }
      
      if ($scope.editBillDateDue == ""){
        $.datepicker._clearDate('#bill_edit_datepicker');
      } else {
        $('#bill_edit_datepicker').datepicker("setDate", $scope.editBillDateDue);
      }

      /** end set date **/
      
      $scope.editBillGroup = $.extend(true, {}, GroupModel.groups[bill.group]);

      $scope.editBillTotal = BillModel.deriveTotal(bill);
      
      var mems = $.extend(true, {}, GroupModel.groups[bill.group].members);

      // make the currentEditMembers an array
      $scope.currentEditMembers = [];
      for (var i in mems){
        $scope.currentEditMembers.push(mems[i]);
      }

      var pending = $.extend(true, {}, GroupModel.groups[bill.group].pending);
      $scope.currentEditPending = [];
      for (var i in pending) {
        $scope.currentEditPending.push(pending[i]);
      }

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
  $scope.currentMembers = [];
  $scope.currentPending = [];

  // Refreshes page bill data 
  getBillFromModel = function(e) {
    BillModel.refresh(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        $scope.$apply(function(){
          // buildBills();
          $scope.combinedBills = BillModel.combinedSummary;
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

  $scope.$watchCollection('combinedBills', function(newVal, oldVal){
    console.log("combined",$scope.combinedBills);
  });

  $scope.$watch('newBillGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = [];
    for (var i in $scope.newBillGroup.members) {
      $scope.currentMembers.push($scope.newBillGroup.members[i]);
    }
    console.log("Current members: ", $scope.currentMembers);

    $scope.currentPending = [];
    for (var i in $scope.newBillGroup.pending) {
      $scope.currentPending.push($scope.newBillGroup.pending[i]);
    }
  });
  
  $scope.notSelf = function(user){
    console.log("comparing ",user, " and ",UserModel.me);
    return user.id != UserModel.me;
  }
  
  // function buildBills(){
  //   buildBillsList();
  //   buildBillsMap();
  // // }

  // $scope.$watch('billsYouOweMap', function(newVal, oldVal){
  //   console.log('billsYouOweMap changed');
  // },true);

  // $scope.$watch('billsYouOwe', function(newVal, oldVal){
  //   console.log('billsYouOwe changed');
  // },true);

  // $scope.$watch('billsOweYouMap', function(newVal, oldVal){
  //   console.log('billsOweYouMap changed');
  // },true);

  // $scope.$watch('billsOweYou', function(newVal, oldVal){
  //   console.log('billsOweYou changed');
  // },true);

  //{person:'Member1', amount: 12, why: 'Bought Lunch'}

  // function buildBillsList(){
  //   $scope.billsYouOwe = [];
  //   $scope.billsOweYou = [];
  //   $scope.billsOweYouMap =[];
  //   $scope.billsYouOweMap =[];

  //   var bills = BillModel.bills;
  //   for(var i in bills){
  //     if(bills[i].creator == UserModel.me){
  //       for(var j in bills[i].membersAmountMap){
  //         if (j != UserModel.me){
  //           $scope.billsOweYou.push({
  //             person: UserModel.users[j].firstname, 
  //             amount: bills[i].membersAmountMap[j].due, 
  //             why: bills[i].title,
  //             id: bills[i].id,
  //             desc: bills[i].description,
  //             due: bills[i].dateDue
  //           });
  //         }
  //       }
        
  //     } else {
  //       for(var j in bills[i].membersAmountMap){
  //         console.log("creater is not me, bills[i]: ",bills[i]);
  //         if (j == UserModel.me){
  //           $scope.billsYouOwe.push({
  //             person: UserModel.users[bills[i].creator].firstname, 
  //             amount: bills[i].membersAmountMap[j].due, 
  //             why: bills[i].title,
  //             id: bills[i].id,
  //             desc: bills[i].description,
  //             due: bills[i].dateDue
  //           });
  //         }
  //       }

  //     }
  //   }
  // }

  // Creates map from user id to the amount they owe
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
      && Object.getOwnPropertyNames(makeMembersAmountMap).length > 0)) {
      e.preventDefault();

      if (!$scope.newBillGroup)
        toastr.error("Group not selected");
      if (!$scope.newBillTitle)
        toastr.error("Bill Name required");
      if ($scope.newBillTotal <= 0)
        toastr.error("Bill total needs to be more than 0");
      if (!(Object.getOwnPropertyNames(makeMembersAmountMap).length > 0))
        toastr.error("No member(s) selected");

      return;
    }

    // Passes data to create bill in backend bill model
    BillModel.createBill(groupID, title, description, dateDue, total, makeMembersAmountMap,
      function(error){
      if(error){
        for (var index in error){
          toastr.error(error[index]);  
        }
      } else{
        $scope.$apply(function(){
          // buildBills();
          $scope.combinedBills = BillModel.combinedSummary;
          initNewBillData();
        });
        toastr.success("Bill Created!");
        $('#billModal').modal('hide');

      }

    });

    
  };

  // Edits bill with given data
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
      && Object.getOwnPropertyNames(makeMembersAmountMap).length > 0)) {
      e.preventDefault();

      if (!$scope.editBillGroup)
        toastr.error("Group not selected");
      if (!$scope.editBillTitle)
        toastr.error("Bill Name required");
      if ($scope.editBillTotal <= 0)
        toastr.error("Bill total needs to be more than 0");
      if (!(Object.getOwnPropertyNames(makeMembersAmountMap).length > 0))
        toastr.error("No member(s) selected");

      return;
    }

    // Passes data to backend to update bill model
    BillModel.editBill(activeEditBill, groupID, title, description, dateDue, total, makeMembersAmountMap,
      function(error){
      if(error){
        for (var index in error){
          toastr.error(error[index]);  
        }
      } else{
        $scope.$apply(function(){
          // buildBills();
          $scope.combinedBills = BillModel.combinedSummary;
          initEditBillData();
        });
        toastr.success("Bill Edited!");
        $('#billEditModal').modal('hide');
      }

    });
  };
    
  // Fills in billsYouOweMap from billsYouOwe
  // function buildBillsMapYouOwe() {
  //   $.each($scope.billsYouOwe, function(bill) {
  //     var found = false;
  //     var bill = this;
  //     $.each($scope.billsYouOweMap, function(member) {
  //       if (this.person == bill.person) {
  //         this.amount += bill.amount;
  //         if (bill.due != null) {
  //           this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: bill.due});
  //         }
  //         else {
  //           this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: "No Date"});
  //         }
  //         found = true;
  //         return false;
  //       }
  //     });
  //     if (!found) {
  //       if (bill.due != null) {
  //         $scope.billsYouOweMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
  //           why: bill.why, desc: bill.desc, due: bill.due}]});
  //       }
  //       else {
  //         $scope.billsYouOweMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
  //           why: bill.why, desc: bill.desc, due: "No Date"}]});  
  //       }
  //     }
  //   });
  // }
    
  // Fills in billsOweYouMap from billsOweYou
  // function buildBillsMapOweYou() {
  //   console.log("building bills map");
  //   $.each($scope.billsOweYou, function(bill) {
  //     var found = false;
  //     var bill = this;
  //     $.each($scope.billsOweYouMap, function(member) {
  //       if (this.person == bill.person) {
  //         this.amount += bill.amount;
  //         if (bill.due != null) {
  //           this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: bill.due});
  //         }
  //         else {
  //           this.bills.push({id: bill.id, amt: bill.amount, why: bill.why, desc: bill.desc, due: "No Date"});
  //         }
  //         found = true;
  //         return false;
  //       }
  //     });
  //     if (!found) {
  //       if (bill.due != null) {
  //         $scope.billsOweYouMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
  //           why: bill.why, desc: bill.desc, due: bill.due}]});
  //       }
  //       else {
  //         $scope.billsOweYouMap.push({person: bill.person, amount: bill.amount, bills: [{id: bill.id, amt: bill.amount, 
  //           why: bill.why, desc: bill.desc, due: "No Date"}]});  
  //       }
  //     }
  //   });
  // }

  // function buildBillsMap(){
  //   buildBillsMapOweYou();
  //   buildBillsMapYouOwe();
  // }

  // select all members in the array when clicked. If all members are selected, unselect them.
  $scope.selectAll = selectAllInArray; // selectAllInArray is a function in main.js

  // function for datepicker to popup
  $(function() {$( "#bill_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});
  $(function() {$( "#bill_edit_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});

  // Function called to open up edit bill modal
  $scope.showEditBill = function(e, billID){
    initEditBillData(BillModel.bills[billID]);
    $('#billEditModal').modal({show:true});
    $("#bill-split-evenly-checkbox2").prop("checked", false);
  };
  
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
    $('.tasks-panelbutton').not($(e.delegateTarget)).css("border", "1px solid white");
    $(".bills-selected").popover();
    $(".bills-selected-owe").popover();
    $(".bills-selected-debt").popover();
  }
  
  // Function when checkbox is clicked. Updates displayed total
  $scope.updateTotal = function(p) {
    var total = 0;
      $('#' + p + 1 + " input:checkbox").each(function () {
        var str = $(this).val();
        str = str.substr(0, str.indexOf(' '));
        
        total += (this.checked ? parseFloat(str) : 0);
      });
    $('#' + p + 1 + " .bill-pop-total").html('Total: $' + total.toFixed(2));
  }

  // Function when bill summary checkboxes are clicked. Updates displayed total
  $scope.updateTotalComb = function(p) {
    var total = 0;
      $('#' + p + 4 + " input:checkbox").each(function () {
        var str = $(this).val();
        str = str.substr(0, str.indexOf(' '));

        if (this.id=="UO") {
          total += (this.checked ? parseFloat(str) : 0);
        } else {
          total -= (this.checked ? parseFloat(str) : 0);
        }
      });
    $('#' + p + 4 + " .bill-pop-total-comb").html('Total: $' + total.toFixed(2));
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
    var a = $('#' + p + 4 + " input:checkbox");
    $('#' + p + 4 + " input:checkbox").each(function () {
      var str = $(this).val().split(" ");
      var billID = parseInt(str[1]);
      var personID = parseInt(str[2])
      // var id = str.substr(str.indexOf(' ')+1);
      if (this.checked) {

        // otherwise, set it to finished
        BillModel.setPaid(billID, personID, function(error) {
          var billTitle = BillModel.bills[billID].title;
          if(error) {
            toastr.warning("billID could not be set paid");
            for (var index in error){
              toastr.error(error[index]);  
            }
          } else {
            $scope.$apply(function() {
              $scope.combinedBills = BillModel.combinedSummary;
              toastr.success("Bill '" + billTitle + "' paid!");
            });
          }
        });



        // $.each($scope.billsYouOweMap, function(member) {
        //   if (this.person == p) {
        //     this.amount -= value;
        //     var list = this.bills
        //     $.each(list, function(i, bill) {
        //       if (this.id == id) {
        //         list.splice(i, 1);
        //         if (list.length == 0) {
        //           $.each($scope.billsYouOweMap, function(i, person) {
        //             if (person.person == p) {
        //               $scope.billsYouOweMap.splice(i, 1);
        //               return false;
        //             }
        //           });
        //         }
        //         return false;
        //       }
        //     });
        //     $('#' + p + 1 + " .bill-pop-total").html('Total: $0');
        //     return false;
        //   }
        // });


      }
    });
    $('.bill-pop').hide();
    $('.bill').css("border", "1px solid white");
  }

  // Called to open the add bill modal
  $('#openBtn').click(function(){
    $('#billModal').modal({show:true})
    $("#bill-split-evenly-checkbox1").prop("checked", false);
  });

  // Opens the help page for bills
  $scope.openBillHelpModal = function(e){
    $('#billHelpModal').modal({show:true})
  };

  // Goes to next help page
  $scope.billNext = function(pageNum) {
    $('#'+'billHelp'+pageNum).hide();
    $('#'+ 'billHelp'+(parseInt(pageNum)+1)).show();
  }

  // Goes to previous help page
  $scope.billBack = function(pageNum) {
    $('#'+'billHelp'+pageNum).hide();
    $('#'+'billHelp'+(parseInt(pageNum)-1)).show();
  }
  
  // Function called to split bills evenly
  $scope.splitEvenly = function(mem, n) {
    if ($("#bill-split-evenly-checkbox" + n).is(":checked")) {
      if (n == 1) {
        var total = $scope.newBillTotal;
      }
      else {
        var total = $scope.editBillTotal;
      }
      var list = $(".bill-members-check" + n + ":checked");
      var value = total / list.size();
      value = Math.round(value * 100) / 100;
      if (n == 1) {
        $.each($scope.currentMembers, function() {
          if (this.chked) {
            this.amount = value;
          }
        });
      }
      else {
        $.each($scope.currentEditMembers, function() {
          if (this.chked) {
            this.amount = value;
          }
        });
      }
      if (mem) {
        mem.amount = value;
      }
    }
  }

  // Called when history is opened to activate popovers
  $scope.openHistory = function() {
    $("#billsHistory .bills-selected-owe").popover();
    $("#billsHistory .bills-selected-debt").popover();
  }

  

}]);

