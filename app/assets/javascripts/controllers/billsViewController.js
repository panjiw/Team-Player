/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "TaskModel", function($scope, TaskModel) {
	$scope.activeBillTab='bill_selected_you_owe';

  $(function () { $("[data-toggle='popover']").popover({ html : true }); });
  $('.btn').on('click', function (e) {
    $('.btn').on('click', function (e) {
        $('.btn').not(this).popover('hide');
    });
  });
  $('a').on('click', function (e) {
      $('.btn').popover('hide');
  });

  $('#openBtn').click(function(){
  	$('#myModal').modal({show:true})
  });

}]);
