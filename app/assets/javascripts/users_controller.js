function UsersController($scope) {
  $scope.login = function(e) {
    if(!$scope.login_uname || !$scope.login_psswd) {
      //TODO
      return;
    }

    var data = {
      uname: $scope.login_uname,
      password: $scope.login_psswd
    }
    console.log(data);

    //TODO
    $.ajax({
      type: "POST",
      url: "http://localhost:3000/createuser",
      dataType: "JSON",
      success: function(data) {
        console.log(data);
        //TODO
      }
    });
  }

  $scope.create_account = function(e) {
    if(!$scope.create_
  }
}
