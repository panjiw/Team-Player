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
    
    $('#calendar-display').fullCalendar({
      events: [
        {
          title: 'All Day Event',
          start: new Date(y, m, 1)
        },
        {
          title: 'Long Event',
          start: new Date(y, m, d-5),
          end: new Date(y, m, d-2)
        },
        {
          title: 'Click for Google',
          start: new Date(y, m, 28),
          end: new Date(y, m, 29),
          url: 'http://google.com/',
          backgroundColor: 'pink'
        }
      ],
      eventClick: function(event) {
        if (event.url) {
            window.open(event.url);
            return false;
        }
      }
    });
    
  });

}]);
