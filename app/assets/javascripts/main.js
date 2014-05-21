/**
 *  TeamPlayer -- 2014
 *
 *  This file declares the angular module "myapp"
 *  for the entire application.
 */

var myApp = angular.module('myapp', ['ui.calendar', 'ui.sortable']);

function compareProperties(a, b){
    if(a == b) {
    	return 0;
    } else if(a < b) {
    	return -1;
    } else {
    	return 1;
    }
}

function sort(input, attributes) {
    if (!angular.isObject(input)) return input;

    var array = [];
    for(var objectKey in input) {
        array.push(input[objectKey]);
    }

    array.sort(function(a, b) {
    	var compare = 0;
    	for(var i = 0; i < attributes.length && compare == 0; i++) {
    		console.log("Looking at: ", attributes[i]);
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

myApp.filter('orderEvents', function() {
	// TODO
	return function(input) {
		console.log("Called unimplemented function")
		return input;
	}
})