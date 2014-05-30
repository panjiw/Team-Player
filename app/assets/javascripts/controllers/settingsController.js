angular.module('myapp').controller("settingsController", ["$scope", "UserModel", 
  function($scope, UserModel) {
  
  $(".settings-btn").click(function(b) {
    $("#" + $(this).attr("value")).show();
    $(".settings-section").not("#" + $(this).attr("value")).hide();
  });
  
  $scope.changeUsername = function() {
    var username = $("#username-username").val();
    var password = $("#username-password").val();
    $.post("/edit_username", // <<----- url can be changed.
    {
      "edit[username]": username,
      "edit[password]": password
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("user edit Success: " , data);
      toastr.success("User name changed!");
      location.reload();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);      
      var messages = JSON.parse(xhr.responseText);
      for (var i in messages){
        toastr.error(messages[i]);
      }
    });
  }
  
  $scope.changePassword = function() {
    var newPassword = $("#password-new-password").val();
    var newPasswordConfirm = $("#password-new-password-confirm").val();
    var oldPassword = $("#password-old-password").val();
    $.post("/edit_password", // <<----- url can be changed.
    {
      "edit[password]": oldPassword,
      "edit[new_password]": newPassword,
      "edit[new_password_confirmation]": newPasswordConfirm
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("user edit Success: " , data);
      toastr.success("password changed!");
      location.reload();
    
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      var messages = JSON.parse(xhr.responseText);
      for (var i in messages){
        toastr.error(messages[i]);
      }
    });
  }
  
  $scope.changeEmail = function() {
    var email = $("#email-email").val();
    var password = $("#email-password").val();
    $.post("/edit_email", // <<----- url can be changed.
    {
      "edit[email]": email,
      "edit[password]": password
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("user edit Success: " , data);
      toastr.success("email changed!");
      location.reload();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      var messages = JSON.parse(xhr.responseText);
      for (var i in messages){
        toastr.error(messages[i]);
      }
    });
  }
  
  $scope.changeName = function() {
    var first = $("#name-first").val();
    var last = $("#name-last").val();
    var password = $("#name-password").val();
    $.post("/edit_name", // <<----- url can be changed.
    {
      "edit[firstname]": first,
      "edit[lastname]": last,
      "edit[password]": password
    })
    .success(function(data, status) { // on success, there will be message to console
      console.log("user edit Success: " , data);
      toastr.success("name changed!");
      location.reload();
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      var messages = JSON.parse(xhr.responseText);
      for (var i in messages){
        toastr.error(messages[i]);
      }
    });
  }
  
}]);