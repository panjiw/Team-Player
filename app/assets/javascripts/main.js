/**
 *  TeamPlayer -- 2014
 *
 *  This file declares the angular module "myapp"
 *  for the entire application.
 */

var myApp = angular.module('myapp', ['ui.calendar', 'ui.sortable']);

function compareProperties(a, b){
  if(a instanceof Date && b instanceof Date) {
    return a.valueOf() - b.valueOf();
  }

  if(a == b) {
  	return 0;
  } else if(a < b) {
  	return -1;
  } else {
  	return 1;
  }
}

function sort(input, attributes) {
  var array;
  if (input instanceof Array) {
    array = input;
  } else {
    array = [];
    for(var objectKey in input) {
      array.push(input[objectKey]);
    }
  }

  array.sort(function(a, b) {
  	var compare = 0;
  	for(var i = 0; i < attributes.length && compare == 0; i++) {
  		//console.log("Looking at: ", attributes[i]);
  		if(attributes[i][0] == "!") {
  			var attrib = attributes[i].substring(1);
  			compare = compareProperties(b[attrib], a[attrib]);
  		} else {
  			compare = compareProperties(a[attributes[i]], b[attributes[i]]);
  		}
  	}
  	return compare;
  });
  return array;
 }



myApp.filter('orderUsers', function(){
 return function(input) {
 	return sort(input, ['username', 'firstname', 'lastname', 'id']);
 };
});

myApp.filter('orderGroups', function() {
	return function(input) {
		return sort(input, ['!isSelfGroup' , 'name', 'description', 'id']);
	}
});

myApp.filter('orderTasks', function() {
	return function(input) {
    return sort(input, ['dateDue', 'title', 'description', 'id']);
  }
});

myApp.filter('orderBills', function() {
  return function(input) {
    return sort(input, ['due', 'why', 'desc', 'id']);
  }
});

myApp.filter('onlyMyTasks', function(){
 return function(input, currentUserID) {
    var result = {};
    for (var taskID in input) {

      for (var userID in input[taskID].members){
        if(userID == currentUserID){
          result[taskID] = input[taskID];
        }
      }
    }
    return result;
 };
});

myApp.filter('accepted', function() {
  return function(input) {
    var result = {};
    for (var id in input) {
      if (input[id].accepted) {
        result[id] = input[id];
      }
    }

    return result;
  };
});

myApp.filter('pending', function() {
  return function(input) {
    var result = {};
    for (var id in input) {
      if (!input[id].accepted) {
        result[id] = input[id];
      }
    }

    return result;
  };
});
