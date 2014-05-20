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

  // get groups before loading task so that group and user info are updated
  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      //$scope.groupsList = groups;
      getTaskFromModel();
    }
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


  $(document).ready(function() {
  
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    
    var events = [];
    
    $.each(TaskModel.getTasksArray(), function() {
      if (this.dueDate != null) {
        var dueDate = this.dueDate.split("-");
        events.push({title: this.taskName, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
          dueDate[2]), backgroundColor: "#fcf8e3", textColor: "black"});
      }
      else {
        $scope.todos.push(this);
      }
    })
    
    $.each(BillModel.bills, function() {
      if (this.event.dateDue != null) {
        var dueDate = this.event.dateDue.split("-");
        events.push({title: this.event.title, start: new Date(dueDate[0], parseInt(dueDate[1]) - 1, 
          dueDate[2]), backgroundColor: "#dff0d8", textColor: "black"});
      }
    })
    
    $('#calendar-display').fullCalendar({
      events: events,
      eventClick: function(event) {
        if (event.url) {
            window.open(event.url);
            return false;
        }
      }
    });
    
  });

}]);
