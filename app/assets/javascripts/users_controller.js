function UsersController($scope) {
  $scope.login = function(e) {
    if(!$scope.login_uname || !$scope.login_psswd) {
      //TODO
      return;
    }

    var data = {
      name: $scope.login_uname,
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
    if((!$scope.create_fname || !$scope.create_lname || 
        !$scope.create_uname || !$scope.create_psswd_one || 
        !$scope.create_psswd_two) || ($scope.create_psswd_one != $scope.create_psswd_two)) {
      //TODO
      return;
    }

    var data = {
      name: $scope.create_uname,
      fname: $scope.create_fname,
      lname: $scope.create_lname,
      password: $scope.create_psswd;
    }

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
}
