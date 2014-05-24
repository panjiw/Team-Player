describe("Group Model Tests", function() {
  var  GroupModel, self, other,selfExpected, otherExpected;
  beforeEach(function() { 
    module("myapp");

    inject(function(_GroupModel_) {
      GroupModel = _GroupModel_;
      expect(GroupModel).toBeDefined();
    });

    selfExpected = new Group(0, true, "name", "description", 1, new Date(), [1]);
    otherExpected = new Group(20, false, "Cool", "Bro", 0, new Date(), [1, 2, 3, 20]);

    self = {
      id: 0,
      self: true,
      name: "name",
      description: "description",
      creator: 1,
      dateCreated: (new Date()).toString(),
      users: [1]
    }

    other = {
      id: 20,
      self: false,
      name: "Cool",
      description: "Bro",
      creator: 0,
      dateCreated: (new Date()).toString(),
      users: [1, 2, 3, 20]
    }
  });

  it("On start, there are no groups, and we have not fetched groups", function() {
    expect(GroupModel.groups).toEqual({});
    expect(GroupModel.fetchedGroups).toBe(false);
  });

  it("Updating groups work", function() {
    expect(GroupModel.groups).toEqual({});

    GroupModel.updateGroup(self);
    GroupModel.updateGroup(other);

    expect(GroupModel.groups[0]).toBeDefined();
    expect(GroupModel.groups[20]).toBeDefined();
  });

  it("refresh all works", function() {
    var called = false, num = 0;
    var obj = {
      refresh: function() {
        called = true;
      }
    };
    var another = {
      refresh: function() {
        num = 1;
      }
    };
    GroupModel.refreshAll([obj, another]);

    expect(called).toBe(true);
    expect(num).toEqual(1);
  });

  it("should return groups", function() {
    GroupModel.fetchedGroups = true;  // pretend we got groups from model
    GroupModel.updateGroup(self);
    GroupModel.getGroups(function(groups, asynch, error) {
      expect(error).toBeFalsy();
      expect(asynch).toBe(false);
      expect(groups).toEqual(GroupModel.groups);
    });
  });
});

