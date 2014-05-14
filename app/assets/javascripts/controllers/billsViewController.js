/*
 *  TeamPlayer -- 2014
 *
 *  This file is not implemented yet. It will be
 *  the controller for the bills page
 */
angular.module('myapp').controller("billsViewController", ["$scope", "BillModel", "GroupModel", 
  function($scope, BillModel, GroupModel) {
  $scope.activeBillTab='bill_selected_you_owe';
  $scope.newBillTitle = "";
  $scope.newBillDescription = "";
  $scope.newBillDateDue = "";
  $scope.newBillTotal = "";
  $scope.newBillGroup = "";
  $scope.newBillMembers = "";

  $scope.groupsList = {};
  $scope.currentMembers = {};

  GroupModel.getGroups(function(groups, asynch, error) {
    if (error){
    } else {
      $scope.groupsList = groups;
    }
  });

  $scope.$watch('groupsList', function(newVal, oldVal){
    console.log('changed');
  });

  $scope.$watch('newBillGroup', function(newVal, oldVal){ 
    console.log('group selected');
    $scope.currentMembers = $scope.newBillGroup.members;
  });
  
  

  $scope.getBillFromModel = function(e) {
    BillModel.getBillFromServer(
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
      }
    });
  }

  $scope.createBill = function(e) {
    // dummy bill data:
    var groupID = 57;
    var title = "bill_title 3";
    var description = "bill_description! 3";
    var dateDue = new Date();
    var total = 30;
    var membersAmountMap = {1:4, 3:6, 4:20};
    BillModel.createBill(groupID, title, description, dateDue, total, membersAmountMap,
      function(error){
      if(error){
        //TODO
      } else{
        //TODO
      }
    });
  };

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
