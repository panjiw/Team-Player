/*
  TeamPlayer -- 2014

  This file holds the model for all bills the user is part of.

  It's main functionality is to get, create, pay, and edit bills.
*/

//Define a bil object as an event with additional fields:
//  --membersAmountMap: the members associated with the bill, and how much each owes
//  --membersPaidMap: which membesr have paid their amounts.
//  --total: is not explicitly a field, but it is a derived field.
var Bill = function(id, creatorID, groupID, title, description, dateCreated, dateDue, cycle, repostArray, membersAmountMap) {
  this.event = new Event(id, creatorID, groupID, title, description, dateCreated, dateDue, cycle, repostArray);
  this.membersAmountMap = membersAmountMap;
  this.membersPaidMap = {};
  for(userID in membersAmountMap) {
    this.membersPaidMap[userID] = false;
  }
};

angular.module("myapp").factory('BillModel', function() {
  var BillModel = {};
  BillModel.bills = {};   //ID to bills.css

  //Create and return a Bill with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  BillModel.createBill = function(groupID, title, description, dateCreated, dateDue, cycle, repostArray, membersAmountMap) { // creator ID
    //TODO
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
