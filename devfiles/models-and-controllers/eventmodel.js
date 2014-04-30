var Event = function() {
	this.id = 0;
	this.group = 0;
	this.title = "";
	this.description = "";
	this.creator = 0;
	this.dateCreated = null;
	this.dateDue = null;
	this.cycle = false;
	this.repost = [false, false, false, false, false, false, false];

	this.createEvent = function() {
		//TODO
	}

	this.editEvent = function(id) {
		//TODO
	}
}

angular.module("myapp").factory('EventModel', function() {
  var EventModel = new Event();

  return EventModel;
});