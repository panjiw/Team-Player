/**
 *  TeamPlayer -- 2014
 *
 *  This file is not yet implemented.
 *  It will be the controller for the tasks page when implemented
 */
angular.module('myapp').controller("tasksViewController", ["$scope", "TaskModel", "GroupModel", "UserModel", 
  function($scope, TaskModel, GroupModel, UserModel) {

  // initialize fields for creating a new task to be empty
  function initNewTaskData(){
    $scope.newTaskGroup = null;
    $scope.newTaskTitle = "";
    $scope.newTaskDescription = "";
    $scope.newTaskDateDue = "";
    $scope.newTaskMembers = {};
    $scope.newTaskCycle = false;
    $scope.newTaskRepostArray = [false,false,false,false,false,false,false];
    $scope.taskRepeat = $scope.noDue = false;

  }

  // getting task from model for the first time, so ask model to get from server
  function getTaskFromModel(){
    TaskModel.getTasksFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        console.log("<<<<task from model!!>>>");
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.getTasksArray();

        });
      }
    });
  }

  // initialize group and members to display for creating tasks
  $scope.groupsList = {};
  $scope.currentMembers = {};

  // get groups before loading task so that group and user info are updated
  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
      console.log("$scope.groupsList",$scope.groupsList);
      getTaskFromModel();
    }
  });

  // build an array of member ids from a collection of user objects
  function buildMemberIdArray(){
    $scope.newTaskMembers = [];
    var count = 0;
    for(var index in $scope.currentMembers){
      if($scope.currentMembers[index].chked){
        $scope.newTaskMembers[count++] = $scope.currentMembers[index].id;
      }
    }
  }

  initNewTaskData();

  // make sure the group list is updated to the view
  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('groupList in task changed', $scope.$groupList);
  });

  $scope.$watch('newTaskGroup', function(newVal, oldVal){ 
    if($scope.newTaskGroup){
      console.log('group selected');
      $scope.currentMembers = $scope.newTaskGroup.members;
      console.log("currentMembers, ", $scope.currentMembers);
    } else {
      $scope.currentMembers = {};
    }
  });
 
  $scope.openModal = function(e){
    $('#taskModal').modal({show:true})
  };

  // $scope.addMember = function(e) {
  //   if(e.which != 13) {   // If they didn't press enter, we don't care
  //     return;
  //   }

  //   $scope.addTask_members.push($scope.newMember);
  //   $scope.newMember = "";
  // }


  // check whether or not the user actually checked the checkboxes
  function noRepeat(){
    for(var index in $scope.newTaskRepostArray){
      if($scope.newTaskRepostArray[index])
        return false;
    }
    return true;
  }

  $scope.myTasks = TaskModel.getTasksArray();

  // build the tasks from variables to the view
  // function buildTasks(){
  //   $scope.myTasks = [];
  //   var tasks = TaskModel.tasks;

  //   for(var i in tasks){
  //     // turn members in this task into a string to display
  //     function memsToString(){
  //       var str = "";
  //       var first = true;
  //       for(var j in tasks[i].members){
  //         if(first){
  //           str+= UserModel.users[j].uname;
  //           first = false;
  //         } else {
  //           str+= ", "+UserModel.users[j].uname;
  //         }
  //       }
  //       return str;
  //     }

  //     $scope.myTasks.push({
  //       taskID: tasks[i].event.id,
  //       taskName: tasks[i].event.title,
  //       taskDesc: tasks[i].event.description,
  //       dueDate: tasks[i].event.dateDue,
  //       groupName: $scope.groupsList[tasks[i].event.group].name,
  //       members: memsToString(),
  //       done: tasks[i].done
  //     });
  //   }
  //   console.log("built tasks: ",$scope.myTasks);
  // }

  $scope.$watch('myTasks', function(newVal, oldVal){
    console.log('myTasks changed');
  }, true);

  // create a task from user input
  $scope.createTask = function(e){
    buildMemberIdArray();

    // get javascript object from datapicker
    $scope.newTaskDateDue = $("#task_datepicker").datepicker( 'getDate' );

    // first perform an empty field check
    if(!$scope.newTaskGroup || !$scope.newTaskTitle 
      || !$scope.newTaskDescription || !$scope.newTaskMembers.length > 0) {
      e.preventDefault();
      
      if (!$scope.newTaskGroup)
        toastr.error("Group not selected");

      if (!$scope.newTaskTitle)
        toastr.error("Task Title required");

      if (!$scope.newTaskDescription)
        toastr.error("Task Description required");

      if (!$scope.newTaskMembers.length > 0)
        toastr.error("Member not selected");
      return;
    }

    function callback(error){
      if(error){
      for (var index in error){
          toastr.error(error[index]);  
        }
      } else {
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.getTasksArray();
        });
        toastr.success("Task Created!");
        $('#taskModal').modal('hide');
      }
    };

    // if normal task
    if(!$scope.newTaskCycle && !$scope.taskRepeat && noRepeat()){
      TaskModel.createTask($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, $scope.newTaskMembers, callback);
      // if special task
    } else{
      TaskModel.createTaskSpecial($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, $scope.newTaskMembers,$scope.newTaskCycle, $scope.newTaskRepostArray, callback);
    }

    // clear out data used to create new task
    initNewTaskData();
  };

  $scope.finish = function(id) {
    // if the task is already done, we have nothing to do
    if(TaskModel.tasks[id].done) {
      return;
    }

    // otherwise, set it to finished
    TaskModel.setFinished(id, function(error) {
      if(error) {
        toastr.warning("Task could not be set finished");
      } else {
        $scope.$apply(function() {
          $scope.myTasks = TaskModel.getTasksArray();
          toastr.success("Task '" + TaskModel.tasks[id].event.title + "' completed!");
        });
      }
    });
  }

  $scope.myTasks = [];

  // function for datepicker to popup
  $(function() {$( "#task_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});

  $scope.openTaskPop = function (e, p) {
    if ($('#' + p).is(':visible')) {
      $('#' + p).hide();
      $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
    }
    else {
      $('#' + p).show();
      $(e.target).find(".panel-heading").css("background-color", "#52d600");
    }
    $('.tasks-pop').not('#' + p).hide();
    $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
  }

  $scope.openEditModal = function(e){
    $('#editModal').modal({show:true})
  };

}]);
