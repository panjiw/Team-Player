/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the main (home) page
 */
angular.module('myapp').controller("homeViewController", 
  ["$scope", "UserModel", "GroupModel", "TaskModel", "BillModel", 
  function($scope, UserModel, GroupModel, TaskModel, BillModel) {

  // $scope.groupsList = {};
  $scope.currentUser = {};
  $scope.todos = [];
  $scope.todaysTasks = [];
  $scope.currentEventType = "";
  $scope.currentEvent = "";

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

  $scope.myTasks = {};
  $scope.myBills = [];
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

  // get groups before loading task so that group and user info are updated
  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      //$scope.groupsList = groups;
      getTaskFromModel();
      getBillFromModel();
      
    }
  });

  // redraw calendar when mytasks and my bills are updated
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

  $('#addTaskBut').click(function(){
    $('#taskModal').modal({show:true})
  });
  
  $('#addBillBut').click(function(){
    $('#billModal').modal({show:true})
  });

  $scope.openModal = function(e){
    $('#manualModal').modal({show:true})
  };

  $scope.openCalendarModal = function(todo) {
    $('#calendarModal').modal({show:true})
    $("#calendarModal-header").html(todo.title);
    $("#calendarModal-content").html("<strong>Description:</strong> " + todo.description + "<br/><br/>" 
                      + "<strong>Group:</strong> " + todo.groupName + "<br/><br/>" 
                      + "<strong>Members:</strong> " + UserModel.usersToUserNamesString(todo.members));
    $scope.currentEventType = "task";
    $scope.currentEvent = todo.id;
  }

  // $(document).ready(function() {
    var dataReady = function() {
    
    var events = [];
    
    $.each($scope.myTasks, function() {
      if (this.dateDue != null) {
        var dueDate = this.dateDue.split("-");
        if (this.done == null) {
          events.push({type: "Task", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#faebcc", textColor: "black", borderColor: "#faebcc", desc: this.description, members: UserModel.usersToUserNamesString(this.members),
            group: this.groupName, eventid: this.id});
        }
        else
        {
          events.push({type: "Task", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#F0F0F0", textColor: "black", borderColor: "#ddd", desc: this.description, members: UserModel.usersToUserNamesString(this.members),
            group: this.groupName, eventid: this.id});
        }
        if (this.dateDue == $.datepicker.formatDate('yy-mm-dd', new Date()) && this.done == null) {
          $scope.todaysTasks.push(this);
        }
      }
      else {
        if (this.done == null) {
          $scope.todos.push(this);
        }
      }
    })
    
    $.each($scope.myBills, function() {
      if (this.dateDue != null) {
        var dueDate = this.dateDue.split("-");
        events.push({type: "Bill", title: this.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
          dueDate[2]), backgroundColor: "#d6e9c6", textColor: "black", borderColor: "#d6e9c6",
          desc: this.description, members: UserModel.users[this.creator].username, group: GroupModel.groups[this.group].name, eventid: this.id});
      }
    })

    
    $('#calendar-display').fullCalendar({
      // editable:true,
      events: events,
      eventClick: function(event) {
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

  $scope.openHomeHelpModal = function(e){
    $('#homeHelpModal').modal({show:true})
  };

  $scope.homeNext = function(pageNum) {
    $('#'+'homeHelp'+pageNum).hide();
    $('#'+'homeHelp'+(parseInt(pageNum)+1)).show();
  }

  $scope.homeBack = function(pageNum) {
    $('#'+'homeHelp'+pageNum).hide();
    $('#'+'homeHelp'+(parseInt(pageNum)-1)).show();
  }
  
  $scope.finishTask = function() {
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
  }

}]);
