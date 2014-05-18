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
    $scope.newTaskGroup = -1;
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
        $scope.$apply(function(){
          buildTasks();
        });
      }
    });
  }

  getTaskFromModel();

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

  // $scope.addTask_members = [];

  // initialize group and members to display for creating tasks
  $scope.groupsList = {};
  $scope.currentMembers = {};

  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
      console.log("$scope.groupsList",$scope.groupsList);
    }
  });

  // make sure the group list is updated to the view
  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('groupList in task changed', $scope.$groupList);
  });

  $scope.$watch('newTaskGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = $scope.newTaskGroup.members;
    console.log("currentMembers, ", $scope.currentMembers);
  });
 
  $scope.openModal = function(e){
    $('#myModal').modal({show:true})
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

  // build the tasks from variables to the view
  function buildTasks(){
    $scope.myTasks = [];
    var tasks = TaskModel.tasks;

    for(var i in tasks){
      // turn members in this task into a string to display
      function memsToString(){
        var str = "";
        var first = true;
        for(var j in tasks[i].members){
          if(first){
            str+= UserModel.users[j].uname;
            first = false;
          } else {
            str+= ", "+UserModel.users[j].uname;
          }
        }
        return str;
      }

      $scope.myTasks.push({
        taskID: 'task'+tasks[i].event.id,
        taskName: tasks[i].event.title,
        taskDesc: tasks[i].event.description,
        dueDate: tasks[i].event.dateDue,
        groupName: $scope.groupsList[tasks[i].event.group].name,
        members: memsToString(),
        done: tasks[i].done
      });
    }
  }

  $scope.$watch('myTasks', function(newVal, oldVal){
    console.log('myTasks changed');
  });

  // create a task from user input
  $scope.createTask = function(e){
    buildMemberIdArray();

    // first perform an empty field check
    if(!($scope.newTaskGroup && $scope.newTaskTitle 
      && $scope.newTaskDescription && $scope.newTaskMembers.length > 0)) {
      e.preventDefault();
      toastr.error("Empty fields");
      return;
    }

    function callback(error){
      if(error){
      //TODO
      } else {
        $scope.$apply(function(){
          buildTasks();
        });
        toastr.success("task created!");
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
    TaskModel.setFinished(id, function(error) {
      if(error) {
        toastr.warning("Task could not be set finished")
      } else {
        buildTasks();
      }
    });
  }

  $scope.myTasks = [];

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
