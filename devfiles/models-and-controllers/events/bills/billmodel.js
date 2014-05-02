// **NOTE: specs such as return values are not set in stone.

var Bill = new Event();
Bill.membersAmountMap = {};
Bill.membersPaidMap = {};
Bill.total = 0;


angular.module("myapp").factory('BillModel', function() {
  var BillModel = {};
  BillModel.bills = {};   //ID to bills

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

  //Return all bills for this user as a list of Bill objects
  BillModel.getBills = function() {
  	
    var dummyBill = new Bill();
    dummyBill.id = 0;
    dummyBill.groupID = 0;
    dummyBill.title = "Dummy Bill";
    dummyBill.description = "pay these dum bill stubs!"
    dummyBill.creator = 0;
    dummyBill.dateCreated = new Date();
    dummyBill.dateDue = new Date();
    dummyBill.cycle = false;
    dummyBill.repost = [false, false, false, false, false, false, false];
    dummyBill.membersAmountMap = {1: 15};
		dummyBill.membersPaidMap = {1: 0};
		dummyBill.total = 15;

		var fakeBill = new Bill();
		fakeBill.id = 0;
    fakeBill.groupID = 0;
    fakeBill.title = "fake Bill";
    fakeBill.description = "pay these fake bills!"
    fakeBill.creator = 0;
    fakeBill.dateCreated = new Date();
    fakeBill.dateDue = new Date();
    fakeBill.cycle = false;
    fakeBill.repost = [false, false, false, false, false, false, false];
    fakeBill.membersAmountMap = {1: 17};
		fakeBill.membersPaidMap = {1: 17};
		fakeBill.total = 17;
    

    return [dummyBill, fakeBill];
  }

  return BillModel;
});
