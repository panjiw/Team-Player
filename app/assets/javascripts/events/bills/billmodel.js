/*
  TeamPlayer -- 2014

  This file holds the model for all bills the user is part of.

  It's main functionality is to get, create, pay, and edit bills.
*/

//Define a bil object as an event with additional fields:
//  --membersAmountMap: the members associated with the bill, and how much each owes, and whether or not it's paid
//    --{userid : {due: int, paid: bool, paid_date: date}}
//  --total: is not explicitly a field, but it is a derived field.
var Bill = function(id,  groupID, title, description, creatorID, dateCreated, dateDue, membersAmountMap) {
  this.id = id;
  this.group = groupID;
  this.title = title;
  this.description = description;
  this.creator = creatorID;
  this.dateCreated = dateCreated;
  this.dateDue = dateDue;
  this.membersAmountMap = membersAmountMap;
  this.amountForEntry = {};
};

var SummaryEntry = function(username) {
  this.person_username = username;
  this.total = 0;
  this.billsArray = [];
    
  this.addBill = function(bill, amountForEntry) {
    this.billsArray.push(bill);
    bill.amountForEntry[this.person_username] = amountForEntry;
    var newTotal = this.total + amountForEntry;

    this.total = parseFloat(newTotal.toFixed(2));
  };
};

angular.module("myapp").factory('BillModel', ['UserModel', function(UserModel) {
  var BillModel = {};
  BillModel.bills = {};   //ID to bills.css
  BillModel.summary = {};

  BillModel.deriveTotal = function(bill){
    var total = 0;
    for (var index in bill.membersAmountMap){
      total += bill.membersAmountMap[index].due;
    }
    total = parseFloat(total.toFixed(2));
    return total;
  };

  function makeSummary() {
    BillModel.summary = {youOwe: {}, oweYou: {}};
    for (var i in BillModel.bills){
      // creator is me, people owe me
      if (BillModel.bills[i].creator == UserModel.me){

        // for each person involved in the bill
        for(var j in BillModel.bills[i].membersAmountMap){
          // if this person is not me, it is one of the people that owes me
          if (j != UserModel.me){

            // if he has not pay
            if (!BillModel.bills[i].membersAmountMap[j].paid){
              // if the person is not in summary, add an entry
              if(!BillModel.summary.oweYou[j]){
                BillModel.summary.oweYou[j] = new SummaryEntry(UserModel.users[j].username);
              } 

              // add the bill in
              BillModel.summary.oweYou[j].addBill(BillModel.bills[i], BillModel.bills[i].membersAmountMap[j].due);
            }
          }
        }

        // creator is not me, I owe him
      } else {

        // if I have not paid
        if (!BillModel.bills[i].membersAmountMap[UserModel.me].paid){
          var bill_creator_id = BillModel.bills[i].creator;
          var bill_creator_username = UserModel.users[BillModel.bills[i].creator].username;

          // if this person is not in summary that i owe him, add an entry
          if(!BillModel.summary.youOwe[bill_creator_id]){
            BillModel.summary.youOwe[bill_creator_id] = new SummaryEntry(bill_creator_username);
          }
          BillModel.summary.youOwe[bill_creator_id].addBill
            (BillModel.bills[i], BillModel.bills[i].membersAmountMap[UserModel.me].due);
        }
      }
    }
  }
  // update a bill to the BillModel.bills map
  BillModel.updateBill = function(bill){
    toDollars(bill.due);

    BillModel.bills[bill.details.id] = new Bill(bill.details.id, bill.details.group_id, bill.details.title, bill.details.description,
     bill.details.user_id, bill.details.created_at, bill.details.due_date, bill.due);
    makeSummary();

    console.log("bill summary made: ", BillModel.summary);
  }

  // get bills from server to bill model
  BillModel.refresh = function(callback){
    $.get("/get_bills")
    .success(function(data, status) {
      console.log("bill get Success: " , data);

      // update every bill
      BillModel.bills = {};
      for (var i in data){
        BillModel.updateBill(data[i]);
      }
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("bill get error: ",error);
      callback(JSON.parse(xhr.responseText));
    });
  }

  function toCents(makeAmountMap){
    for (var userID in makeAmountMap) {
      makeAmountMap[userID] *= 100;
    }
  }

  function toDollars(membersAmountMap){
    for (var userID in membersAmountMap) {
      var num = membersAmountMap[userID].due / 100;
      membersAmountMap[userID].due = parseFloat(num.toFixed(2));
    }
  }

  //Create and return a Bill with the given parameters. This updates to the database, or returns
  //error codes otherwise...
  BillModel.createBill = function(groupID, title, description, dateDue, total, makeMembersAmountMap, callback) { // creator ID
    toCents(makeMembersAmountMap);

    $.post("/create_bill",
    {
      "bill[group_id]": groupID,
      "bill[title]": title,
      "bill[description]": description,
      "bill[due_date]": dateDue,
      "bill[total_due]": total*100,
      "bill[members]": makeMembersAmountMap
    })
    .success(function(data, status) {
      console.log("bill create Success: " , data);
      BillModel.updateBill(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("bill create error: ",error);
      callback(JSON.parse(xhr.responseText));
    });
  };

  //Update a bill with all of the fields. If a field is null, it is not updated
  BillModel.editBill = function(billID, groupID, title, description, dateDue, total, makeMembersAmountMap, callback) { // creator ID
    toCents(makeMembersAmountMap);

    /******* the following block of code should be modified and used when backend "edit_bill" is ready ****/

    $.post("/edit_bill",
    {
      "bill[id]": billID,
      "bill[group_id]": groupID,
      "bill[title]": title,
      "bill[description]": description,
      "bill[due_date]": dateDue,
      "bill[total_due]": total*100,
      "bill[members]": makeMembersAmountMap
    })
    .success(function(data, status) {
      console.log("bill edit Success: " , data);
      BillModel.updateBill(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("bill edit error: ",error);
      callback(JSON.parse(xhr.responseText));
    });
  };

  BillModel.setPaid = function(billID, callback) {
    if(!billID) {
      callback({1:"no bill id provided"});
    }

    $.post("/finish_bill",
    {
      "bill[id]": billID
    })
    .success(function(data, status) {
      
        console.log("finished data", data);
        // updateTask(data.task);
        // updateGenerator(data.generator);

        
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // //Return all bills.css for this user as a list of Bill objects
  // BillModel.getBills = function() {
  //   //TODO ajax

  //   //Dummy objects for now
  //   var sevenFalse = [false, false, false, false, false, false, false];
  //   var dummyBill = new Bill(0, 0, 0, "Dummy Bill", "Pay me!", new Date(), new Date(), false, sevenFalse, {1: 17});
  //   var fakeBill = new Bill(0, 0, 0, "Fake Bill", "Pay me some more!", new Date(), new Date("5/23/2014"), false, sevenFalse, {1: 15});    

  //   return [dummyBill, fakeBill];
  // }

  return BillModel;
}]);
