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
        var dueDate = this.dateDue.split("-");
        
        // If task is not finished yet, display normally
        if (this.done == null) {
          events.push({type: "Task", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#faebcc", textColor: "black", borderColor: "#faebcc", desc: this.description, members: UserModel.usersToUserNamesString(this.members),
            group: this.groupName, eventid: this.id});
        }
        
        // Else task is completed, display as completed
        else
        {
          events.push({type: "Task", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#F0F0F0", textColor: "black", borderColor: "#ddd", desc: this.description, members: UserModel.usersToUserNamesString(this.members),
            group: this.groupName, eventid: this.id});
        }
        
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
        
        // If bill is not paid, display on calendar normally
        if (!this.membersAmountMap[UserModel.me].paid) {
          var dueDate = this.dateDue.split("-");
          events.push({type: "Bill", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#d6e9c6", textColor: "black", borderColor: "#d6e9c6",
            desc: this.description, members: UserModel.users[this.creator].username, group: GroupModel.groups[this.group].name, eventid: this.id});
        }
        
        // Else bill is paid, display bill as completed
        else {
          var dueDate = this.dateDue.split("-");
          events.push({type: "Bill", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#F0F0F0", textColor: "black", borderColor: "#d6e9c6",
            desc: this.description, members: UserModel.users[this.creator].username, group: GroupModel.groups[this.group].name, eventid: this.id});
        }
      }
    })

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
