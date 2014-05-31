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
  $scope.currentEvent = -1;
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
    }
  });

  // Retrieves information about tasks from the task model
  function getTaskFromModel(){
    TaskModel.refresh(
      function(error){
      if(error){
        // do nothing
      } else{
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.tasks;
          // initialize me to a variable for filter
          $scope.myID = UserModel.me;
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
    $('#calendar-display').empty();
    $scope.todos = [];
    $scope.todaysTasks = [];
    dataReady();
  });

  // Opens up add task modal
  $('#addTaskBut').click(function(){
    $('#taskModal').modal({show:true})
  });
  
  // Opens up add bill modal
  $('#addBillBut').click(function(){
    $('#billModal').modal({show:true})
  });


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
    $scope.todos = [];
    
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
          backgroundColor: this.dateDue.valueOf() < new Date().valueOf() ? "#ffcfcf" : "#ffffb3", 
          borderColor: this.dateDue.valueOf() < new Date().valueOf() ? "#ffcfcf" : "#ffffb3", 
          members: UserModel.usersToUserNamesString(this.members),
          group: this.groupName, 
          eventid: this.id
        };

        // If task is not finished yet, display normally
        if (this.done == null) {

          //If task is mine, display with box
          if (TaskModel.isInvolved(this.id)) {
            newEventObj["backgroundColor"] = this.dateDue.valueOf() < new Date().valueOf() ? "#ff8282" : "#ffef00"; //yellow
            newEventObj["borderColor"] = this.dateDue.valueOf() < new Date().valueOf() ? "#ff8282" : "#ffef00";
          }
        }
        // finished 
        else {
          // if (TaskModel.isInvolved(this.id)) {
              newEventObj["backgroundColor"] = "white"; //gray
              newEventObj["borderColor"] = "white";
          // }
        }
        events.push(newEventObj);
        
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
      
      // If bill has a date, put in calendar
      if (this.dateDue != null) {
        var newEventObj = {
          type: "Bill", 
          title: this.title, 
          start: this.dateDue, 
          backgroundColor: "#d6e9c6", 
          textColor: "black", 
          borderColor: "#d6e9c6",
          desc: this.description, 
          members: UserModel.users[this.creator].username, 
          group: GroupModel.groups[this.group].name, 
          eventid: this.id
        };

        // If bill is not paid, display on calendar normally
        if (!this.membersAmountMap[UserModel.me].paid) {

          //If I have to pay bill, display with box
          if (this.creator != UserModel.me) {
              newEventObj["backgroundColor"] = "#7ab847";
              newEventObj["borderColor"] = "#7ab847";
          }
        }
        // Else bill is paid, display bill as completed
        else {
            newEventObj["backgroundColor"] = "white";
            newEventObj["borderColor"] = "white";
        }
        events.push(newEventObj);
      }
    });

    var displayEvents = function(date) {
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

     //create panels in a string
     var string = "";
      $.each(thisDateTasks, function() {
         var taskPanel = "";
         var completeBtn = "";

          //task not done
          if (this.done == null) {
            taskPanel = "<div class='panel panel-warning'>" + 
                    "<div class='panel-heading'>" + 
                      "<div class='task-panel'>";
            //a task I'm responsible for
            if (TaskModel.isInvolved(this.id)) {
              // completeBtn = "<button class='btn btn-success btn-xs'>Completed</button>";
            } 
            //a task I'm not responsible for
            else {
              completeBtn = "Not Your Task";
            }
          } 
          // task done
          else {
            taskPanel = "<div class='panel panel-gray'>" + 
                    "<div class='panel-heading panel-gray-header'>" +
                      "<div class='task-panel'>";
          }

        string += taskPanel + 
                        "<h4 class='panel-descr'>" + this.title + "</h4>" + 
                        "<h4 class='panel-date'>" + 
                          completeBtn +
                        "</h4>" +
                      "</div>" + 
                    "</div>" + 
                     "<div class='panel-body panel-info'>" + 
                       "<div class='panel-groupname'>" + this.groupName + "</div>" + 
                     "</div>" + 
                  "</div>";
      })

      $.each(thisDateBills, function() {
        //created by you...need to say owed to who?
          //paid: pink (no words)
          //unpaid: gray (no words)
        //not created by you...
          //paid: gray (say paid)
          //unpaid: green (pay button)

        var billColor = "";
        var paidTag = "";

        //You created the bill
        if (this.bill.creator == UserModel.me) {
          //the bill has been paid, gray
          if (this.owe.paid){
            billColor = "<div class='panel panel-gray'>" + 
                    "<div class='panel-heading panel-gray-header'>" +
                      "<div class='task-panel'>";
            paidTag = "<div>" + "paid" + "</div>";
          } 
          //the bill has not been paid, pink
          else {
            billColor = "<div class='panel panel-danger'>" + 
                    "<div class='panel-heading'>" + 
                      "<div class='task-panel'>";
          }
        } 
        //you need to pay the bill
        else {
          //the bill has been paid, gray with Paid note
          if (this.owe.paid){
            billColor = "<div class='panel panel-gray'>" + 
                    "<div class='panel-heading panel-gray-header'>" +
                      "<div class='task-panel'>";
            paidTag = "<div>" + "paid by you" + "</div>";
          } 
          //the bill has not been paid, green with pay button
          else {
            billColor = "<div class='panel panel-success'>" + 
                    "<div class='panel-heading'>" + 
                      "<div class='task-panel'>";
            // paidTag = "<button class='btn btn-success btn-xs' ng-click='finishEvent()' data-dismiss='modal'>" +
            //         "pay" + "</button>";
          }
        }

        string += billColor + 
                        "<h4 class='panel-descr'>" + this.bill.title + "</h4>" + 
                        "<h4 class='panel-date'>" + paidTag +
                         "</h4>" +
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
    };

    // Adds given task/bill information to calendar
    $('#calendar-display').fullCalendar({
      // editable:true,
      events: events,
      dayClick: function(date, allDay, jsEvent, view) {
        displayEvents(date);
      },
      eventClick: function(event, jsEvent, view) {
        displayEvents(event.start);
      }
    });  
  };

  // Opens up legend modal for home
  $scope.openLegendModal = function(e){
    $('#legendModal').modal({show:true})
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
            dataReady();
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
            dataReady();
            toastr.success("Bill '" + billTitle + "' paid!");
          });
        }
      });
    }
  }

}]);
