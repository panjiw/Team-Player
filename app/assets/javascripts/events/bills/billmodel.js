/*
  TeamPlayer -- 2014

  This file holds the model for all bills the user is part of.

  It's main functionality is to get, create, pay, and edit bills.
*/

//Define a bil object as an event with additional fields:
//  --membersAmountMap: the members associated with the bill, and how much each owes
//  --membersPaidMap: which membesr have paid their amounts.
//  --total: is not explicitly a field, but it is a derived field.
var Bill = function(id,  groupID, title, description, creatorID, dateCreated, dateDue, membersAmountMap, membersPaidMap) {
  this.event = new Event(id, groupID, title, description, creatorID, dateCreated, dateDue);
  this.membersAmountMap = membersAmountMap;
  this.membersPaidMap = membersPaidMap;
  for(userID in membersAmountMap) {
    this.membersPaidMap[userID] = false;
  }
};

angular.module("myapp").factory('BillModel', function() {
  var BillModel = {};
  BillModel.bills = {};   //ID to bills.css

  BillModel.updateBill = function(bill){
    //BillModel.bills[bill.id] = new Bill(bill.id, bill.groupID, bill.title, bill.description, creatorID, dateCreated, dateDue, membersAmountMap, membersPaidMap)
  }

  BillModel.getBillFromServer = function(callback){
    $.get("/get_bills")
    .success(function(data, status) {
      console.log("bill get Success: " , data);
      // update bill
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("bill get error: ",error);
      callback("Error: " + JSON.parse(xhr.responseText));
    });
  }

  //Create and return a Bill with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  BillModel.createBill = function(groupID, title, description, dateDue, total, membersAmountMap, callback) { // creator ID
    $.post("/create_bill",
    {
      "bill[group_id]": groupID,
      "bill[title]": title,
      "bill[description]": description,
      "bill[due_date]": dateDue,
      "bill[total_due]": total,
      "bill[members]": membersAmountMap,
    })
    .success(function(data, status) {
      console.log("bill create Success: " , data);
      // update bill
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("bill create error: ",error);
      callback("Error: " + JSON.parse(xhr.responseText));
    });
  };

  //Update a bill with all of the fields. If a field is null, it is not updated
  BillModel.editBill = function(billID, title, description, dateCreated, dateDue, cycle, repostArray, membersAmountMap) {
    //TODO
  };

  // Set that a member of the bill has paid
  BillModel.paidBy = function(billID, userID) {

  }

  //Return all bills.css for this user as a list of Bill objects
  BillModel.getBills = function() {
    //TODO ajax

    //Dummy objects for now
    var sevenFalse = [false, false, false, false, false, false, false];
    var dummyBill = new Bill(0, 0, 0, "Dummy Bill", "Pay me!", new Date(), new Date(), false, sevenFalse, {1: 17});
    var fakeBill = new Bill(0, 0, 0, "Fake Bill", "Pay me some more!", new Date(), new Date("5/23/2014"), false, sevenFalse, {1: 15});    

    return [dummyBill, fakeBill];
  }

  return BillModel;
});
