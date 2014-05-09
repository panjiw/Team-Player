/**
 *  TeamPlayer -- 2014
 *
 *  This file is not yet implemented.
 *  It will be the controller for the tasks page when implemented
 */
angular.module('myapp').controller("tasksViewController", ["$scope", "TaskModel", function($scope, TaskModel) {
 
  $scope.openModal = function(e){
  	$('#myModal').modal({show:true})
  };


// 	$('input[type="checkbox"].large').checkbox({
// 	    buttonStyle: 'btn-link',
// 		// buttonStyleChecked: 'btn-inverse',
// 		checkedClass: 'icon-check',
// 		uncheckedClass: 'icon-check-empty',
// 		// constructorCallback: null,
// 		// defaultState: false,
// 		// defaultEnabled: true,
		 
// 		// checked: false,
// 		// enabled: true
// 	});

// $("[data-toggle=popover]").popover();
}]);
