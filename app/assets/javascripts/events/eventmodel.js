/*
	Team Chronus -- 2014

	This file just declares the prototype of an event object.
	Any "subtype" of event must contain these fields. 
*/

//Create a new event with the given params:
//	--id: the event id for the new event
//	--group: the id of the group it belongs to
//	--title: a short title
//	--description: a description
//	--creator: the id of teh user who craeted the event
//	--dateCreated: the Date object for when the event was created
//	--dateDue: the Date object for when the event is due
//	--cycle: a boolean representing whether this event cycles between the members
//	--repostArray: the days of the week to repeat this event (if any) as an array of booleans
var Event = function(eventID, groupID, title, description, creatorID, dateCreated, dateDue) {
	this.id = eventID;
	this.group = groupID;
	this.title = title;
	this.description = description;
	this.creator = creatorID;
	this.dateCreated = dateCreated;
	this.dateDue = dateDue;
}