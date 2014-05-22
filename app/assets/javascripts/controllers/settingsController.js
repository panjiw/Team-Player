angular.module('myapp').controller("settingsController", ["$scope", function($scope) {
  
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
      updateTask(data);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      callback(JSON.parse(xhr.responseText));
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
      updateTask(data);
      callback();
    
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      callback(JSON.parse(xhr.responseText));
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
      updateTask(data);
      callback();
      
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      callback(JSON.parse(xhr.responseText));
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
      updateTask(data);
      callback();
    
    })
    .fail(function(xhr, textStatus, error) {
      console.log("user edit error: ",error);
      callback(JSON.parse(xhr.responseText));
    });
  }
  
}]);