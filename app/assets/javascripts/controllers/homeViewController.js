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

  $scope.myTasks = [];
  $scope.myBills = [];
  function getTaskFromModel(){
    TaskModel.getTasksFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        console.log("<<<< home view: task from model!!>>>");
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.getTasksArray();
          
        });
      }
    });
  }

  getBillFromModel = function(e) {
    BillModel.getBillFromServer(
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
    $("#calendarModal-header").html(todo.taskName);
    $("#calendarModal-content").html("<strong>Description:</strong> " + todo.taskDesc + "<br/><br/>" 
                      + "<strong>Group:</strong> " + todo.groupName + "<br/><br/>" 
                      + "<strong>Members:</strong> " + todo.members);
  }

  // $(document).ready(function() {
    var dataReady = function() {
    
    var events = [];
    
    $.each($scope.myTasks, function() {
      if (this.dueDate != null) {
        var dueDate = this.dueDate.split("-");
        if (this.done == null) {
          events.push({type: "Task", title: this.taskName, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "#fcf8e3", textColor: "black", desc: this.taskDesc, members: this.members,
            group: this.groupName});
        }
        else
        {
          events.push({type: "Task", title: this.taskName, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
            dueDate[2]), backgroundColor: "grey", textColor: "black", desc: this.taskDesc, members: this.members,
            group: this.groupName});
        }
        if (this.dueDate == $.datepicker.formatDate('yy-mm-dd', new Date()) && this.done == null) {
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
      if (this.event.dateDue != null) {
        var dueDate = this.event.dateDue.split("-");
        events.push({type: "Bill", title: this.event.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
          dueDate[2]), backgroundColor: "#dff0d8", textColor: "black", 
          desc: this.event.description, members: UserModel.users[this.event.creator].username, group: GroupModel.groups[this.event.group].name});
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
        }
        else {
          $("#calendarModal-content").html("<strong>Description:</strong> " + event.desc + "<br/><br/>" 
                    + "<strong>Group:</strong> " + event.group + "<br/><br/>" 
                    + "<strong>Creator:</strong> " + event.members);
        }
      }
    });
    
  }; // });

}]);
