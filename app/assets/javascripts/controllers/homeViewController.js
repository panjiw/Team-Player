/*
 *  TeamPlayer -- 2014
 *
 *  This is the Angular Controller for the viewing home page.
 *  It contains the calendar and todos which can be used to manage tasks/bills
 */
angular.module('myapp').controller("homeViewController", 
  ["$scope", "UserModel", "GroupModel", "TaskModel", "BillModel", 
  function($scope, UserModel, GroupModel, TaskModel, BillModel) {

  // Set $scope variables to default
  $scope.currentUser = {};
  $scope.todos = [];
  $scope.todaysTasks = [];
  $scope.currentEventType = "";
  $scope.currentEvent = "";
  $scope.myTasks = {};
  $scope.myBills = [];

  // Retrives information about current user to user model
  UserModel.fetchUserFromServer(function(error){
    if(error){
      //TODO
    } else {
      $scope.$apply(function(){
        $scope.currentUser = UserModel.get(UserModel.me);
      })
      console.log("fetch user success!");
    }
  });

  // Retrieves information about tasks from the task model
  function getTaskFromModel(){
    TaskModel.refresh(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        console.log("<<<< home view: task & task gen from model!!>>>");
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.tasks;
        });
      }
    });
  }


  // Retrieves information about bills from bill model
  getBillFromModel = function(e) {
    BillModel.refresh(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        $scope.$apply(function(){
          $scope.myBills = BillModel.bills;    
          $scope.billSummary = BillModel.summary;
        });
      }
    });
  };

  // Get groups before loading task so that group and user info are updated
  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      //$scope.groupsList = groups;
      getTaskFromModel();
      getBillFromModel();
      
    }
  });

  // Re-draw calendar when mytasks and my bills are updated
  $scope.$watchCollection('[myTasks,myBills]', function(newVal, oldVal){
    console.log('myTasks in home changed', $scope.myTasks);
    $('#calendar-display').empty();
    $scope.todos = [];
    $scope.todaysTasks = [];
    dataReady();
  });

  // GroupModel.getGroups(function(groups, asynch, error) {
  //   if (error){
  //     console.log("fetch group error:");
  //     console.log(error);
  //   } else {
  //     function groupsToApply() {
  //       $scope.groupsList = groups;
  //     }
  //     if(asynch) {
  //       console.log("Asynch groups got:", groups);
  //       $scope.$apply(groupsToApply);
  //     } else {
  //       groupsToApply();
  //     }
  //   }
  // });

  // Opens up add task modal
  $('#addTaskBut').click(function(){
    $('#taskModal').modal({show:true})
  });
  
  // Opens up add bill modal
  $('#addBillBut').click(function(){
    $('#billModal').modal({show:true})
  });

  /* 
  $scope.openModal = function(e){
    $('#manualModal').modal({show:true})
  }; */

  // Opens up modal for bills/tasks inside calendar
  $scope.openCalendarModal = function(todo) {
    $('#calendarModal').modal({show:true})
    $("#calendarModal-header").html(todo.title);
    $("#calendarModal-content").html("<strong>Description:</strong> " + todo.description + "<br/><br/>" 
                      + "<strong>Group:</strong> " + todo.groupName + "<br/><br/>" 
                      + "<strong>Members:</strong> " + UserModel.usersToUserNamesString(todo.members));
    $scope.currentEventType = "task";
    $scope.currentEvent = todo.id;
  }

  // Function called to update information in calendar
  var dataReady = function() {
    
    var events = [];
    
    // Iterates through all of users tasks
    $.each($scope.myTasks, function() {
      
      // If the task has a due date, put in calendar
      if (this.dateDue != null) {
        var newEventObj = {
          type: "Task", 
          title: this.title, 
          start: this.dateDue,
          desc: this.description, 
          textColor: "black",
          backgroundColor: "white",
          borderColor: "white",
          members: UserModel.usersToUserNamesString(this.members),
          group: this.groupName, 
          eventid: this.id
        };


// // display a red background if the task is overdue 
//               backgroundColor: this.dateDue.valueOf() > new Date().valueOf() ? "#D00000" : "#faebcc", 
//               borderColor: "#faebcc",
// events.push(newEventObj);

        // If task is not finished yet, display normally
        if (this.done == null) {

          //If task is mine, display with box
          if (TaskModel.isInvolved(this.id)) {
              newEventObj["backgroundColor"] = "#faebcc"; //yellow
              newEventObj["borderColor"] = "#faebcc";
          } else {
            newEventObj["textColor"] = "#FBB117";
          }
        }
        // finished 
        else {
          if (TaskModel.isInvolved(this.id)) {
              newEventObj["backgroundColor"] = "#F0F0F0"; //gray
          } else {
            newEventObj["textColor"] = "gray";
          }
        }
        events.push(newEventObj);
        // Else task is completed, display as completed
        // else
        // {
        //   events.push({type: "Task", title: this.title, start: this.dateDue, backgroundColor: "#F0F0F0", textColor: "black", borderColor: "#ddd", desc: this.description, members: UserModel.usersToUserNamesString(this.members),
        //     group: this.groupName, eventid: this.id});
        // }
        
        // If task is not finished and is due today, put in todays tasks
        if (this.dateDue == $.datepicker.formatDate('yy-mm-dd', new Date()) && this.done == null) {
          $scope.todaysTasks.push(this);
        }
      }
      
      // If dateless, put in todos
      else {
        if (this.done == null) {
          $scope.todos.push(this);
        }
      }
    })
    
    // Iterates through all of users bills
    $.each($scope.myBills, function() {
      var newEventObj = {
          type: "Bill", 
          title: this.title, 
          start: this.dateDue, 
          backgroundColor: "white", 
          textColor: "black", 
          borderColor: "white",
          desc: this.description, 
          members: UserModel.users[this.creator].username, 
          group: GroupModel.groups[this.group].name, 
          eventid: this.id
        };
      
      // If bill has a date, put in calendar
      if (this.dateDue != null) {

        // If bill is not paid, display on calendar normally
        if (!this.membersAmountMap[UserModel.me].paid) {

          //If I have to pay bill, display with box
          if (this.creator != UserModel.me) {
              newEventObj["backgroundColor"] = "#d6e9c6"; //yellow
              newEventObj["borderColor"] = "#d6e9c6";
          }
          // Otherwise, I had created the bill
          else {
            newEventObj["textColor"] = "green";
          }
        }
        // Else bill is paid, display bill as completed
        else {
          //If it was one I had to pay
          if (this.creator != UserModel.me) {
              newEventObj["backgroundColor"] = "#F0F0F0"; //yellow
              newEventObj["borderColor"] = "#F0F0F0";
          }
          // Otherwise, I had created the bill
          else {
            newEventObj["textColor"] = "gray";
          }
        }
        events.push(newEventObj);

        
        // // If bill is not paid, display on calendar normally
        // if (!this.membersAmountMap[UserModel.me].paid) {
        //   events.push({type: "Bill", title: this.title, start: this.dateDue, backgroundColor: "#d6e9c6", textColor: "black", borderColor: "#d6e9c6",
        //     desc: this.description, members: UserModel.users[this.creator].username, group: GroupModel.groups[this.group].name, eventid: this.id});
        // }
        
        // // Else bill is paid, display bill as completed
        // else {
        //   events.push({type: "Bill", title: this.title, start: this.dateDue, backgroundColor: "#F0F0F0", textColor: "black", borderColor: "#d6e9c6",
        //     desc: this.description, members: UserModel.users[this.creator].username, group: GroupModel.groups[this.group].name, eventid: this.id});
        // }
      }
    });

    // Adds given task/bill information to calendar
    $('#calendar-display').fullCalendar({
      // editable:true,
      events: events,
      eventClick: function(event) { // Function for when calendar event is clicked
        $('#calendarModal').modal({show:true})
        $("#calendarModal-header").html(event.title);
        if (event.type == "Task") {
          $("#calendarModal-content").html("<strong>Description:</strong> " + event.desc + "<br/><br/>" 
                  + "<strong>Group:</strong> " + event.group + "<br/><br/>" 
                  + "<strong>Members:</strong> " + event.members);
          $scope.currentEventType = "task";
          $scope.currentEvent = event.eventid;
        }
        else {
          $("#calendarModal-content").html("<strong>Description:</strong> " + event.desc + "<br/><br/>" 
                    + "<strong>Group:</strong> " + event.group + "<br/><br/>" 
                    + "<strong>Creator:</strong> " + event.members);
          $scope.currentEventType = "bill";
          $scope.currentEvent = event.eventid;
        }
        if (event.backgroundColor == "#F0F0F0") {
          $("#calendarModal-buttons").hide();
        }
        else {
          $("#calendarModal-buttons").show();
        }
      },
      dayClick: function(date, allDay, jsEvent, view) {

        var thisDateTasks = [];
        var thisDateBills = {};

        // Iterates through all of users tasks
        $.each($scope.myTasks, function() {
          if (this.dateDue != null) {
            if ((this.dateDue.getMonth() == date.getMonth()) && 
              (this.dateDue.getDate() == date.getDate()) &&
              (this.dateDue.getFullYear() == date.getFullYear())) {
                thisDateTasks.push(this);
            }
          }
        });

        thisDateBills = BillModel.getBillsOnDay(date);

        console.log("thisDateBills",thisDateBills);

       //create panels in a string
       var string = "";
        $.each(thisDateTasks, function() {
          string += "<div class='panel panel-warning'>" + 
                      "<div class='panel-heading'>" + 
                        "<div class='task-panel'>" + 
                          "<h4 class='panel-descr'>" + this.title + "</h4>" + 
                          "<h4 class='panel-date'>" + this.dateDue.toLocaleDateString() + "</h4>" +
                          // "| date:'shortDate'</h4>" + 
                        "</div>" + 
                      "</div>" + 
                       "<div class='panel-body panel-info'>" + 
                         "<div class='panel-groupname'>" + this.groupName + "</div>" + 
                       //   "<div class='panel-groupmembers'>" +
                       //      "<span ng-repeat='mem in this.members'>" + 
                       //        mem | userNameInTask:task.id:isSpecial(task.id) + "</span></div>" + 
                       "</div>" + 
                    "</div>";
        })
        $.each(thisDateBills, function() {
          var paidTag = "";
          if (this.owe.paid){
            paidTag = "<div>" + "paid" + "</div>";
          } else {
            paidTag = "<button class='btn btn-success btn-xs' ng-click='finishEvent()' data-dismiss='modal'>" +
            "pay" + "</button>";
          }
          string += "<div class='panel panel-success'>" + 
                      "<div class='panel-heading'>" + 
                        "<div class='task-panel'>" + 
                          "<h4 class='panel-descr'>" + this.bill.title + "</h4>" + 
                          "<h4 class='panel-date'>" + paidTag +
                           "</h4>" +
                          // "| date:'shortDate'</h4>" + 
                        "</div>" + 
                      "</div>" + 
                       "<div class='panel-body panel-info'>" + 
                         "<div class='panel-groupname'>" +
                         "Created By: " + this.ownerUsername +
                         "</div>" + 
                         "<div class='panel-groupmembers'>" +
                            "$" + this.owe.due +
                         "</div>" +
                       "</div>" + 
                    "</div>";
        })

        //display modal
        $('#dateModal').modal({show:true})
        $("#dateModal-header").html("Tasks and Bills for: " + date.toLocaleDateString());
        $('#dateModal-content').html(string);

        // change the day's background color just for fun
        $(this).css('background-color', 'pink');

    }
    });  
  };

  // Opens up help modal for home
  $scope.openHomeHelpModal = function(e){
    $('#homeHelpModal').modal({show:true})
  };

  // Moves to next help page
  $scope.homeNext = function(pageNum) {
    $('#'+'homeHelp'+pageNum).hide();
    $('#'+'homeHelp'+(parseInt(pageNum)+1)).show();
  }

  // Moves to previous help page
  $scope.homeBack = function(pageNum) {
    $('#'+'homeHelp'+pageNum).hide();
    $('#'+'homeHelp'+(parseInt(pageNum)-1)).show();
  }
  
  // Completes currently opened event on calendar/todos
  $scope.finishEvent = function() {
    
    // If currently opened event is task, complete task
    if ($scope.currentEventType == "task") {
      var id = $scope.currentEvent;
      // if the task is already done, we have nothing to do
      if(TaskModel.tasks[id].done) {
        return;
      }

      var oldTaskTitle = TaskModel.tasks[id].title;

      // otherwise, set it to finished
      TaskModel.setFinished(id, function(error) {
        if(error) {
          toastr.warning("Task could not be set finished");
        } else {
          $scope.$apply(function() {
            $scope.myTasks = TaskModel.tasks;
            toastr.success("Task '" + oldTaskTitle + "' completed!");
          });
        }
      });
    }
    
    // Else currently opened event is bill, pay bill
    else if ($scope.currentEventType == "bill") {
      var billID = $scope.currentEvent;
      BillModel.setPaid(billID, function(error) {
        var billTitle = BillModel.bills[billID].title;
        if(error) {
          toastr.warning("billID could not be set paid");
          for (var index in error){
            toastr.error(error[index]);  
          }
        } else {
          $scope.$apply(function() {
            $scope.billSummary = BillModel.summary;
            toastr.success("Bill '" + billTitle + "' paid!");
          });
        }
      });
    }
  }

}]);
