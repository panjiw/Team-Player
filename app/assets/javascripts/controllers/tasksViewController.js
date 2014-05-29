/**
 *  TeamPlayer -- 2014
 *
 * This is the Angular Controller for the viewing tasks page.
 * It contains the logic for creating, editing, finishing, and viewing tasks
 */
angular.module('myapp').controller("tasksViewController", ["$scope", "TaskModel", "GroupModel", "UserModel", 
  function($scope, TaskModel, GroupModel, UserModel) {

  // initialize fields for creating a new task to be empty
  function initNewTaskData(){
    $scope.newTaskGroup = null;
    $scope.newTaskTitle = "";
    $scope.newTaskDescription = "";
    $scope.newTaskDateDue = "";
    $scope.newTaskCycle = false;
    $scope.newTaskRepostArray = [false,false,false,false,false,false,false];
    $scope.taskRepeat = $scope.noDue = false;
    $('#task_datepicker').datepicker("setDate", new Date());
  }

  // function for datepicker to popup
  $(function() {$( "#task_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});
  $(function() {$( "#task_edit_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});

  // the current task being edited is not set, default to -1
  var activeEditTask = -1;

  // initialize fields for editing a task to be the original task's info
  function initEditTaskData(task, generator){
    // reset if task field is null
    if (!task){
      activeEditTask = -1;
      return;
    }
    
    // if the current task is the same, don't re initialize
    if (activeEditTask != task.id){
      // clone a map of groups from groupmodel
      $scope.editTaskGroup = $.extend(true, {}, GroupModel.groups[task.group]);
      activeEditTask = task.id;

      // set the title and description
      $scope.editTaskTitle = task.title;
      $scope.editTaskDescription = task.description;

      /** set the date; bill.dateDue is returning an object in the format of: 
          {0:2, 1:0, 2:1,3:4,5:-,6:0,7:5,8:-,9:1,10:4} 
          for 2014-05-14, so need to parse it with indexing **/
      var dateObj = $.extend(true, {}, task.dateDue);

      // if there is a date in the task
      if (dateObj){
        var year = parseInt(""+dateObj[0] + dateObj[1] + dateObj[2] + dateObj[3]);
        var month = parseInt(""+dateObj[5] + dateObj[6]);
        month -=1;
        var day = parseInt(""+dateObj[8] + dateObj[9]);

        // make it a Date object
        $scope.editTaskDateDue = new Date(year,month,day);
      } else {
        // if there is no date initially, make date empty
        $scope.editTaskDateDue = "";
      }
      
      // clear the date field if no initial date
      if ($scope.editTaskDateDue == ""){
        $.datepicker._clearDate('#task_edit_datepicker');
      } else {
        // initialize the datepicker input box 
        $('#task_edit_datepicker').datepicker("setDate", $scope.editTaskDateDue);
      }

      /** end set date **/


      /********** start rearange member according to task list *******/
      // clone current members from groupmodel
      $scope.currentEditMembers = $.extend(true, {}, GroupModel.groups[task.group].members);
      
      // set checked for each involved member
      for (var id in task.members){
        for (var index in $scope.currentEditMembers){
          if($scope.currentEditMembers[index].id == id){
            $scope.currentEditMembers[index].chked = true;
          }
        }
      }
      /*** end ***/

      // if there is a generator, (the task either cycle, repeat, or both), initialize with data in it
      if (generator){
        $scope.editTaskCycle = generator.details.cycle;
        $scope.editTaskRepostArray = [];
        $scope.editTaskRepeat = false;

        // populate the repost array
        for (var id in generator.details.repeat_days){
          $scope.editTaskRepostArray.push(generator.details.repeat_days[id]);

          // if it is repeating someday
          if(generator.details.repeat_days[id])
            $scope.editTaskRepeat = true;
        }
      } else {
        // if the task initially does not cycle or repeat, make the field false
        $scope.editTaskCycle = false;
        $scope.editTaskRepostArray = [false,false,false,false,false,false,false];
        $scope.editTaskRepeat = false;
      }
      
      // if the task initially has a duedate, set the checkbox to be unchecked
      if (task.dateDue)
        $scope.editNoDue = false;
      else 
        $scope.editNoDue = true;
    }
  }

  // getting task from model for the first time, so ask model to get from server
  function getTaskFromModel(){
  TaskModel.refresh(
      function(error){
      if(error){
        // display every error
        for (var index in error){
          toastr.error(error[index]);  
        }
      } else{
        // updates mytasks after getting task is done
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.tasks;
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
      // display every error
      for (var index in error){
          toastr.error(error[index]);  
        }
    } else {
      $scope.groupsList = groups;
      getTaskFromModel();
    }
  });

  // build an array of member ids from a collection of user objects
  function buildMemberIdArray(members){
    var taskMembers = [];
    var count = 0;
    for(var index in members){
      if(members[index].chked){
        taskMembers[count++] = members[index].id;
      }
    }
    return taskMembers;
  }

  // initialize new task data when this file is loaded
  initNewTaskData();

  // make sure the group list is updated to the view
  $scope.$watch('groupsList', function(newVal, oldVal){});

  $scope.$watch('newTaskGroup', function(newVal, oldVal){ 
    if($scope.newTaskGroup){
      // in create task modal, update current members to be selected if group has changed
      $scope.currentMembers = $scope.newTaskGroup.members;
    } else {
      $scope.currentMembers = {};
    }
  });
 
  $scope.openModal = function(e){
    $('#taskModal').modal({show:true});
  };

  $scope.openEditModal = function(e, taskID){
    console.log("open edit");
    initEditTaskData(TaskModel.tasks[taskID],TaskModel.generators[taskID]);
    $('#taskEditModal').modal({show:true});
  };


  // check whether or not the user actually checked the checkboxes
  function noRepeat(repostArray){
    for(var index in repostArray){
      if(repostArray[index])
        return false;
    }
    return true;
  }

  // fill repost array with falses for each field that is not true
  function fillRepostArray(repostArray){
    for(var i = 0; i < 7; i++){
      if(!repostArray[i]){
        repostArray[i] = false;
      }
    }
  }

  // get tasks one time when this file is loaded.
  $scope.myTasks = TaskModel.tasks;

  // use watch to update my tasks in view everytime my task has changed
  $scope.$watch('myTasks', function(){});

  // create a task from user input
  $scope.createTask = function(e){
    var createTaskMembers = buildMemberIdArray($scope.currentMembers);

    // get javascript object from datapicker
    if ($scope.noDue) 
      $scope.newTaskDateDue = null;
    else
      $scope.newTaskDateDue = $("#task_datepicker").datepicker( 'getDate' );

    // first perform an empty field check
    if(!$scope.newTaskGroup || !$scope.newTaskTitle 
      || !$scope.newTaskDescription || !createTaskMembers.length > 0) {
      e.preventDefault();
      
      if (!$scope.newTaskGroup)
        toastr.error("Group not selected");

      if (!$scope.newTaskTitle)
        toastr.error("Task Title required");

      if (!$scope.newTaskDescription)
        toastr.error("Task Description required");

      if (!createTaskMembers.length > 0)
        toastr.error("Member not selected");

      if (!$scope.noDue && $scope.newTaskDateDue == null)
        toastr.error("Date not specified");
      return;
    }

    if (!$scope.noDue && $scope.newTaskDateDue == null){
        toastr.error("Date not specified");
      return;
    }

    // called when both special task and normal task are being created
    function callback(error){
      if(error){
      for (var index in error){
          toastr.error(error[index]);
        }
      } else {
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.tasks;
          // clear out data used to create new task
          initNewTaskData();

          // uncheck people in current members
          for(var index in $scope.currentMembers){
            $scope.currentMembers[index].chked = false;
          }
        });
        toastr.success("Task Created!");
        $('#taskModal').modal('hide');
      }
    };

    // if normal task, call createTask from model
    if(!$scope.newTaskCycle && (!$scope.taskRepeat || noRepeat($scope.newTaskRepostArray))){
      TaskModel.createTask($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, createTaskMembers, callback);

      // if special task, call createTaskSpecial
    } else{
      fillRepostArray($scope.newTaskRepostArray);
      TaskModel.createTaskSpecial($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, createTaskMembers,$scope.newTaskCycle, $scope.newTaskRepostArray, callback);
    }

  };

  // edit a task from user input
  $scope.editTask = function(e) {
    var generatorID = null;
    // if there is a generator, which means active task was speical before edit
    if(TaskModel.generators[activeEditTask]){
      generatorID = TaskModel.generators[activeEditTask].details.id;
    }

    // make a user map from user input of array of members
    var editTaskMembers = buildMemberIdArray($scope.currentEditMembers);

    // get javascript object from datapicker
    if ($scope.editNoDue) 
      $scope.editTaskDateDue = null;
    else
      $scope.editTaskDateDue = $("#task_edit_datepicker").datepicker( 'getDate' );

    // first perform an empty field check
    if(!$scope.editTaskGroup || !$scope.editTaskTitle 
      || !$scope.editTaskDescription || !editTaskMembers.length > 0) {
      e.preventDefault();
      
      if (!$scope.editTaskGroup)
        toastr.error("Group not selected");

      if (!$scope.editTaskTitle)
        toastr.error("Task Title required");

      if (!$scope.editTaskDescription)
        toastr.error("Task Description required");

      if (!editTaskMembers.length > 0)
        toastr.error("Member not selected");

      if (!$scope.editNoDue && $scope.editTaskDateDue == null)
        toastr.error("Date not specified");

      return;
    }

    if (!$scope.editNoDue && $scope.editTaskDateDue == null){
        toastr.error("Date not specified");
      return;
    }

    // called when both special task and normal task are being edited    
    function callback(error){
      if(error){
      for (var index in error){
          toastr.error(error[index]);  
        }
      } else {
         $scope.$apply(function(){

          $scope.myTasks = TaskModel.tasks;
          // clear out data used to create new task
          initEditTaskData();

        });
        toastr.success("Task Edited!");
        $('#taskEditModal').modal('hide');
      }
    };

    // if normal task
    if(!$scope.editTaskCycle && (!$scope.editTaskRepeat || noRepeat($scope.editTaskRepostArray))){
      TaskModel.editTask(activeEditTask, $scope.editTaskGroup.id, $scope.editTaskTitle, $scope.editTaskDescription, 
      $scope.editTaskDateDue, false, editTaskMembers, callback, generatorID);

      // if special task
    } else{
      fillRepostArray($scope.editTaskRepostArray);
      TaskModel.editTaskSpecial(activeEditTask, $scope.editTaskGroup.id, $scope.editTaskTitle, $scope.editTaskDescription, 
      $scope.editTaskDateDue, false, editTaskMembers,$scope.editTaskCycle, $scope.editTaskRepostArray, callback, generatorID);
    }

  };

  // called when user finish a task
  $scope.finish = function(id) {
    // if there is no id input
    if(!id){
      toastr.warning("Invaid task selected");
      return;
    }

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

  // open or close popup when clicking on task
  $scope.openTaskPop = function (e, p, n) {
    if ($('#' + p + n).is(':visible')) {
      $('#' + p + n).hide();
      $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
    }
    else {
      $('#' + p + n).show();
      $(e.target).find(".panel-heading").css("background-color", "#52d600");
    }
    $('.tasks-pop').not('#' + p + n).hide();
    $(e.target).find(".panel-heading").css("background-color", "#FCF8E3");
  }

  $scope.openTaskHelpModal = function(e){
    $('#taskHelpModal').modal({show:true})
  };

  // flip page in help modal
  $scope.taskNext = function(pageNum) {
    $('#'+'taskHelp'+pageNum).hide();
    $('#'+'taskHelp'+(parseInt(pageNum)+1)).show();
  }

  $scope.taskBack = function(pageNum) {
    $('#'+'taskHelp'+pageNum).hide();
    $('#'+'taskHelp'+(parseInt(pageNum)-1)).show();
  }

  // initialize me to a variable for filter
  $scope.myID = UserModel.me;
}]);
