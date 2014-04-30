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
}

angular.module("myapp").factory('EventModel', function() {
  var EventModel = {};
  EventModel.events = [];
	EventModel.createEvent = function() {
		//TODO
	};
	
	EventModel.editEvent = function(id) {
		//TODO
	}

	EventModel.getEvents = function() {
		var eventsCopy = [];
		for(event in events) {
			
		}
	}

  return EventModel;
});