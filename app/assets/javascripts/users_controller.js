function UsersController($scope) {
	$scope.title = "Hello, world";
  $scope.login = function() {
    var data = {}
    //TODO
    $.ajax({
      type: "GET",
      url: //TODO,
      dataType: "JSON",
      success: function(data) {
        console.log(data);
        //TODO
      }
    });
  }
}
