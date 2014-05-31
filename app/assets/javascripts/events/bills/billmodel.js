/*
  TeamPlayer -- 2014

  This file holds the model for all bills the user is part of.

  It's main functionality is to get, create, pay, and edit bills.
*/

//Define a bil object as an event with additional fields:
//  --id: the bill's id
//  --group: the group with which this bill is associated
//  --title: the title of the bill
//  --description: a more detailed description of the bill
//  --creator: the id of the creator of this bill
//  --dateCreated: the date on which the bill was created
//  --dateDue: the date on which the bill is due
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

// A "summary entry" is one person's total bill to you, or you two them.
// The main field is the billsArray, which is the list of bills
// that make up the bill for the person.
var SummaryEntry = function(username) {
  this.person_username = username;
  this.total = 0;
  this.billsArray = [];
    
  this.addBill = function(bill, amountForEntry) {
    this.billsArray.push(bill);
    bill.amountForEntry[this.person_username] = amountForEntry;
    var newTotal = this.total + amountForEntry;

    // round the total to two decimal places because it is currency
    this.total = parseFloat(newTotal.toFixed(2));
  };
};

angular.module("myapp").factory('BillModel', ['UserModel', function(UserModel) {
  var BillModel = {};
  BillModel.bills = {};   //ID to bills.css
  BillModel.summary = {}; // the summary for this person

  // return the total for this bill
  BillModel.deriveTotal = function(bill){
    var total = 0;
    for (var index in bill.membersAmountMap){
      total += bill.membersAmountMap[index].due;
    }
    total = parseFloat(total.toFixed(2));
    return total;
  };

  // return all the bills on a specific date, used by calendar
  BillModel.getBillsOnDay = function(date){
    var thisDayBill = {};

    // for each bill
    for (var i in BillModel.bills) {
      // if it is dateless, move on
      if(!BillModel.bills[i].dateDue)
        continue;

      // if the date matches
      if ((BillModel.bills[i].dateDue.getMonth() == date.getMonth()) && 
          (BillModel.bills[i].dateDue.getDate() == date.getDate()) &&
          (BillModel.bills[i].dateDue.getFullYear() == date.getFullYear())) {
        // if I am not the owner of the bill; so the calendar day popup only display 
        // bills that I owe someone else
        // if (BillModel.bills[i].creator != UserModel.me){

          // I am the owner of the bill or not, does not matter.
          { 
          var amtMap = BillModel.bills[i].membersAmountMap;
          thisDayBill[i] = {
            bill: BillModel.bills[i], // bill object
            owe : amtMap[UserModel.me], //{due: int, paid: bool, paid_date: date}
            ownerUsername : UserModel.users[BillModel.bills[i].creator].username // string
          }
        }
      }
    }
    return thisDayBill;
  };

  // make a "summary" for the user based on all the bills
  // in BillModel.Bills. 
  // This should contain a SummaryEntry for each person
  // you owe, and everybody who owes you money. 
  function makeSummary() {
    BillModel.summary = {youOwe: {}, oweYou: {}, youOweHistory: {}, oweYouHistory: {}};
    for (var i in BillModel.bills){
      // creator is me, people owe me
      if (BillModel.bills[i].creator == UserModel.me){
        for(var j in BillModel.bills[i].membersAmountMap){

          // if this person is not me, it is one of the people that owes me
          if (j != UserModel.me){
            if (!BillModel.bills[i].membersAmountMap[j].paid){
              // if the person is not in summary, add an entry
              if(!BillModel.summary.oweYou[j]){
                BillModel.summary.oweYou[j] = new SummaryEntry(UserModel.users[j].username);
              } 

              // add the bill in
              BillModel.summary.oweYou[j].addBill(BillModel.bills[i], BillModel.bills[i].membersAmountMap[j].due);
            }
            else {
              if(!BillModel.summary.oweYouHistory[j]){
                BillModel.summary.oweYouHistory[j] = new SummaryEntry(UserModel.users[j].username);
              } 

              // add the bill in
              BillModel.summary.oweYouHistory[j].addBill(BillModel.bills[i], BillModel.bills[i].membersAmountMap[j].due);
            }
          }
        }
      } else {  // creator is not me, I owe him

        // if I have not paid, then we need to add it into the summary
        // otherwise, it is irrelevant for now
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
        else {
          var bill_creator_id = BillModel.bills[i].creator;
          var bill_creator_username = UserModel.users[BillModel.bills[i].creator].username;

          // if this person is not in summary that i owe him, add an entry
          if(!BillModel.summary.youOweHistory[bill_creator_id]){
            BillModel.summary.youOweHistory[bill_creator_id] = new SummaryEntry(bill_creator_username);
          }

          BillModel.summary.youOweHistory[bill_creator_id].addBill
            (BillModel.bills[i], BillModel.bills[i].membersAmountMap[UserModel.me].due);
        }
      }
    }
  }
  // update a bill to the BillModel.bills map
  BillModel.updateBill = function(bill){
    toDollars(bill.due);

    var created_at = formatDate(bill.details.created_at);
    var due_date = bill.details.due_date ? formatDate(bill.details.due_date) : null;
    BillModel.bills[bill.details.id] = new Bill(bill.details.id, bill.details.group_id, bill.details.title, bill.details.description,
     bill.details.user_id, created_at, due_date, bill.due);
    makeSummary();
  }

  // get all bills from server and clear out any
  // old data in the BillModel
  BillModel.refresh = function(callback){
    $.get("/get_bills")
    .success(function(data, status) {
      BillModel.bills = {};
      for (var i in data){
        BillModel.updateBill(data[i]);
      }
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  }

  function toCents(makeAmountMap){
    for (var userID in makeAmountMap) {
      makeAmountMap[userID] *= 100;
    }
  }

  // figure out the total for each member in the member amount
  // map, rounding to 2 decimal places
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
      BillModel.updateBill(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  //Update a bill with all of the fields. If a field is null, it is not updated
  BillModel.editBill = function(billID, groupID, title, description, dateDue, total, makeMembersAmountMap, callback) { // creator ID
    toCents(makeMembersAmountMap);

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
      BillModel.updateBill(data);
      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };

  // "Pay" this bill to inform the person you owe
  // that you paid the bill. Then, get store the updated bill
  BillModel.setPaid = function(billID, callback) {
    if(!billID) {
      callback({1:"no bill id provided"});
    }

    $.post("/finish_bill",
    {
      "bill[id]": billID
    })
    .success(function(data, status) {
      BillModel.updateBill(data);

      callback();
    })
    .fail(function(xhr, textStatus, error) {
      callback(JSON.parse(xhr.responseText));
    });
  };
  return BillModel;
}]);
