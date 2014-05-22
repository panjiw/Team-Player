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
    $scope.newTaskCycle = false;
    $scope.newTaskRepostArray = [false,false,false,false,false,false,false];
    $scope.taskRepeat = $scope.noDue = false;

  }

  var activeEditTask = -1;

  function initEditTaskData(task, generator){
    // reset if task field is null
    if (!task){
      activeEditTask = -1;
      return;
    }
    console.log("initedit");
    if (activeEditTask != task.event.id){
      $scope.editTaskGroup = $.extend(true, {}, GroupModel.groups[task.event.group]);
      activeEditTask = task.event.id;

      $scope.editTaskTitle = task.event.title;
      $scope.editTaskDescription = task.event.description;

      /** set the date; somehow bill.event.dateDue is returning and object like 
          {0:2, 1:0, 2:1,3:4,5:-,6:0,7:5,8:-,9:1,10:4} for 2014-05-14, so need to parse it
          weirdly with indexing **/
      var dateObj = $.extend(true, {}, task.event.dateDue);
      if (dateObj){
        var year = parseInt(""+dateObj[0] + dateObj[1] + dateObj[2] + dateObj[3]);
        var month = parseInt(""+dateObj[5] + dateObj[6]);
        month -=1;
        var day = parseInt(""+dateObj[8] + dateObj[9]);

        console.log("dateobj, ", dateObj);
        $scope.editTaskDateDue = new Date(year,month,day);
      } else {
        $scope.editTaskDateDue = "";
      }
      

      console.log("date due",$scope.editTaskDateDue);
      if ($scope.editTaskDateDue == ""){
        $.datepicker._clearDate('#task_edit_datepicker');
      } else {
        $('#task_edit_datepicker').datepicker("setDate", $scope.editTaskDateDue);
      }

      /** end set date **/


      /********** start rearange member according to task list *******/
      // $scope.currentEditMembers = GroupModel.groups[task.event.group].members;
      $scope.currentEditMembers = $.extend(true, {}, GroupModel.groups[task.event.group].members);
      console.log("currentEditMembers from ", GroupModel.groups[task.event.group].members);
      console.log("currentEditMembers", $scope.currentEditMembers);
      console.log("taskmem", task.members);


      var memArray = [];
      var count = 0;
      // set checked for each involved member
      for (var id in task.members){
        for (var index in $scope.currentEditMembers){
          if($scope.currentEditMembers[index].id == id){
            $scope.currentEditMembers[index].chked = true;
            memArray[task.members[id]] = $scope.currentEditMembers[index];
            delete $scope.currentEditMembers[index];
            count++;
          }
            
        }
      }

      for (var index in $scope.currentEditMembers){
        memArray[count++] = $scope.currentEditMembers[index];
      }
      $scope.currentEditMembers = memArray;

      console.log("currentEditMembers after", $scope.currentEditMembers);

      /*** end ***/

      // if there is a generator, initialize with data in it
      if (generator){
        $scope.editTaskCycle = generator.details.cycle;
        $scope.editTaskRepostArray = [];
        $scope.editTaskRepeat = false;
        for (var id in generator.repeat_days){
          $scope.editTaskRepostArray.push(generator.repeat_days[id]);

          // if it is repeating someday
          if(generator.repeat_days[id])
            $scope.editTaskRepeat = true;
        }
      } else {
        $scope.editTaskCycle = false;
        $scope.editTaskRepostArray = [false,false,false,false,false,false,false];
        $scope.editTaskRepeat = false;
      }
      
      if (task.event.dateDue)
        $scope.editNoDue = false;
      else $scope.editNoDue = true;

      
    }
  }

  // getting task from model for the first time, so ask model to get from server
  function getTaskFromModel(){
    TaskModel.getTasksFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        console.log("---- task from model!! ---");
        $scope.$apply(function(){
          $scope.myTasks = TaskModel.getTasksArray();

        });
      }
    });

    TaskModel.getTaskGeneratorsFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
        console.log("---- task gen from model!! ---");
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

  // $scope.$watch('editTaskGroup', function(newVal, oldVal){ 
  //   if(activeEditTask != -1){
  //     if($scope.editTaskGroup){
  //       console.log('edit group selected', $scope.editTaskGroup );
  //       $scope.currentEditMembers = $scope.editTaskGroup.members;
  //       console.log("currentEditMembers, ", $scope.currentEditMembers);
  //     } else {
  //       $scope.currentEditMembers = {};
  //     }
  //   }
  // });
 
  $scope.openModal = function(e){
    $('#taskModal').modal({show:true});
  };

  $scope.openEditModal = function(e, taskID){
    console.log("open edit");
    initEditTaskData(TaskModel.tasks[taskID],TaskModel.generators[taskID]);
    $('#taskEditModal').modal({show:true});
  };

  // $scope.addMember = function(e) {
  //   if(e.which != 13) {   // If they didn't press enter, we don't care
  //     return;
  //   }

  //   $scope.addTask_members.push($scope.newMember);
  //   $scope.newMember = "";
  // }


  // check whether or not the user actually checked the checkboxes
  function noRepeat(repostArray){
    for(var index in repostArray){
      if(repostArray[index])
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
    var createTaskMembers = buildMemberIdArray($scope.currentMembers);

    // get javascript object from datapicker
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
          // clear out data used to create new task
          initNewTaskData();

          for(var index in $scope.currentMembers){
            $scope.currentMembers[index].chked = false;
          }
        });
        toastr.success("Task Created!");
        $('#taskModal').modal('hide');
      }
    };

    // if normal task
    if(!$scope.newTaskCycle && !$scope.taskRepeat && noRepeat($scope.newTaskRepostArray)){
      TaskModel.createTask($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, createTaskMembers, callback);
      // if special task
    } else{
      TaskModel.createTaskSpecial($scope.newTaskGroup.id, $scope.newTaskTitle, $scope.newTaskDescription, 
      $scope.newTaskDateDue, createTaskMembers,$scope.newTaskCycle, $scope.newTaskRepostArray, callback);
    }

  };

  $scope.editTask = function(e) {


    var editTaskMembers = buildMemberIdArray($scope.currentEditMembers);

    // get javascript object from datapicker
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
          // clear out data used to create new task
          initEditTaskData();

        });
        toastr.success("Task Edited!");
        $('#taskEditModal').modal('hide');
      }
    };

    // if normal task
    if(!$scope.editTaskCycle && !$scope.editTaskRepeat && noRepeat($scope.editTaskRepostArray)){
      TaskModel.editTask(activeEditTask, $scope.editTaskGroup.id, $scope.editTaskTitle, $scope.editTaskDescription, 
      $scope.editTaskDateDue, editTaskMembers, callback);

      // if special task
    } else{
      TaskModel.editTaskSpecial(activeEditTask, $scope.editTaskGroup.id, $scope.editTaskTitle, $scope.editTaskDescription, 
      $scope.editTaskDateDue, editTaskMembers,$scope.editTaskCycle, $scope.editTaskRepostArray, callback);
    }

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

  // $scope.myTasks = [];

  // function for datepicker to popup
  $(function() {$( "#task_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});
  $(function() {$( "#task_edit_datepicker" ).datepicker({ minDate: 0, maxDate: "+10Y" });});

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

  $scope.taskNext = function(pageNum) {
    $('#'+'taskHelp'+pageNum).hide();
    $('#'+'taskHelp'+(parseInt(pageNum)+1)).show();
  }

  $scope.taskBack = function(pageNum) {
    $('#'+'taskHelp'+pageNum).hide();
    $('#'+'taskHelp'+(parseInt(pageNum)-1)).show();
  }

  $scope.createdTasks = [];


  $.each($scope.myTasks, function() {
    if (this.creator == UserModel.me) {
      $scope.createdTasks.push(this);
    }
  });

  // $.each(TaskModel.tasks, function() {
  //   if (this.creator == UserModel.me) {
  //     $scope.createdTasks.push(this);
  //   }
  // });

  $scope.$watch('createdTasks', function(newVal, oldVal){
    console.log('createdTasks in task changed', $scope.createdTasks);
  });



}]);
