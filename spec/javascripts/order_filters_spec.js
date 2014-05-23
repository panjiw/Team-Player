describe("Order filters tests", function() {

beforeEach(function() {
  module("myapp");
});

  describe("user filter test", function() {
    var userFilter = {}, smaller = {}, bigger = {}, medium = {};
    beforeEach(function() {
      inject(function(_$filter_) {
        userFilter = _$filter_("orderUsers");
        expect(userFilter).toBeDefined();
      });

      smaller = new User(3, "alpha", "Test", "Testman");
      medium = new User(2, "beta", "Test", "Testman");
      bigger = new User(1, "test", "Test", "Testman");
    });

    it("Empty object returns empty", function() {
      expect(userFilter({})).toEqual([]);
    });

    it("One returns just that", function() {
      var id = smaller.id;
      expect(userFilter({id : smaller})).toEqual([smaller]);
    });

    it("Orders different usernames correctly", function() {
      var biggerId = bigger.id;
      var smallerId = smaller.id;
      expect(userFilter({biggerId: bigger, smallerId: smaller})).toEqual([smaller, bigger]);
    });

    it("Orders username conflict by first name, then last name, then id", function() {
      var user = new User(1, "name", "firstname", "lastname");
      var copyUserName = new User(2, "name", "bro","lastname");
      var copyTwo = new User(3, "name", "bro", "yo");
      var copyCat = new User(4, "name", "firstname", "lastname");

      expect(userFilter({1: user, 2: copyUserName})).toEqual([copyUserName, user]);
      expect(userFilter({1: user, 3: copyTwo})).toEqual([copyTwo, user]);
      expect(userFilter({1: user, 4: copyCat})).toEqual([user, copyCat]);
    });

    it("Filter works on array in any configuration", function() {
      expect(userFilter([smaller, medium, bigger])).toEqual([smaller, medium, bigger]);
      expect(userFilter([medium, smaller, bigger])).toEqual([smaller, medium, bigger]);
      expect(userFilter([bigger, smaller, medium])).toEqual([smaller, medium, bigger]);
      expect(userFilter([medium, bigger, smaller])).toEqual([smaller, medium, bigger]);
      expect(userFilter([smaller, bigger, medium])).toEqual([smaller, medium, bigger]);
      expect(userFilter([bigger, medium, smaller])).toEqual([smaller, medium, bigger]);
    });
  });

  describe("group filter test", function() {
    var groupFilter, smaller, bigger, medium;
    beforeEach(function() {
      inject(function(_$filter_) {
        groupFilter = _$filter_("orderGroups");
        expect(groupFilter).toBeDefined();
      });

      selfSmall = new Group(1, true, "alpha", "description", 1, new Date(), [1]);
      selfBig = new Group(2, true, "beta", "bro", 1, new Date(), [1]);
      normalSmall = new Group(3, false, "alpha", "cool", 1, new Date(), [1]);
      normalBig = new Group(4, false, "alpha", "hi", 1, new Date(), [1]);
    });

    it("Empty object returns empty", function() {
      expect(groupFilter({})).toEqual([]);
    });

    it("One returns just that", function() {
      var id = selfSmall.id;
      expect(groupFilter({id : selfSmall})).toEqual([selfSmall]);
    });

    it("Orders self groups first", function() {
      expect(groupFilter([normalSmall, selfSmall, normalBig])).toEqual([selfSmall, normalSmall, normalBig]);
    });

    it("Orders by group name, then description, then id", function() {
      var base = selfSmall;

      var sameName = selfBig;
      sameName.name = base.name;

      var sameDescription = sameName;
      sameDescription.description = sameName.description;

      // order by description if same name and self groups
      expect(groupFilter([base, sameName])).toEqual([sameName, base]);

      // then by id
      expect(groupFilter([base, sameDescription])).toEqual([sameDescription, base]);
    });
  });

  describe("tasks filter test", function() {
    var taskFilter, today, tomorrow, nextDayAfter, dateless;
    beforeEach(function() {
      inject(function(_$filter_) {
        taskFilter = _$filter_("orderTasks");
        expect(taskFilter).toBeDefined();
      });

      today = {dateDue: new Date(), title: "name", description: "description", id: 1};

      tomorrow = today;
      tomorrow.dateDue.setDate(tomorrow.dateDue.getDate() + 1);

      nextDayAfter = today;
      nextDayAfter.dateDue.setDate(nextDayAfter.dateDue.getDate() + 2);

      dateless = today;
      dateless.dateDue = "";
    });

    it("Empty object returns empty", function() {
      expect(taskFilter({1: today})).toEqual([today]);
    });

    it("One returns just that", function() {
      var id = selfSmall.id;
      expect(taskFilter({})).toEqual([]);
    });

    it("Orders by date first with dateless first", function() {
      expect(taskFilter([tomorrow, today, nextDayAfter, dateless])).toEqual([dateless, today, tomorrow, nextDayAfter]);
    });

    it("then orders by name, then description, then id", function() {
      var base = today;
      base.title = today.title += "longer";

      var sameName = base;
      sameName.description = base.description += "longer";

      var sameDescription = base;
      sameDescription.id = today.id += 1;

      // order by name if dates are equal
      expect(taskFilter([base, today])).toEqual([today, base]);

      // order by description if same name and self groups
      expect(taskFilter([sameName, base])).toEqual([base, sameName]);

      // finally by id
      expect(taskFilter([sameDescription, base])).toEqual([base, sameDescription]);
    });
  });

  describe("bills filter test", function() {
    var billFilter, today, tomorrow, nextDayAfter;
    beforeEach(function() {
      inject(function(_$filter_) {
        billFilter = _$filter_("orderBills");
        expect(billFilter).toBeDefined();
      });

      today = {due: new Date(), why: "name", desc: "description", id: 1};

      tomorrow = today;
      tomorrow.due.setDate(tomorrow.due.getDate() + 1);

      nextDayAfter = today;
      nextDayAfter.due.setDate(nextDayAfter.due.getDate() + 2);

      dateless = today;
      dateless.due = "";
    });

    it("Empty object returns empty", function() {
      expect(billFilter({})).toEqual([]);
    });

    it("One returns just that", function() {
      expect(billFilter({1: today})).toEqual([today]);
    });

    it("Orders by date first with dateless first", function() {
      expect(billFilter([tomorrow, today, nextDayAfter, dateless])).toEqual([dateless, today, tomorrow, nextDayAfter]);
    });

    it("then orders by name, then description, then id", function() {
      var base = today;
      base.why = today.why += "longer";

      var sameName = base;
      sameName.desc = base.desc += "longer";

      var sameDescription = base;
      sameDescription.id = today.id += 1;

      // order by name if dates are equal
      expect(billFilter([base, today])).toEqual([today, base]);

      // order by description if same name and self groups
      expect(billFilter([sameName, base])).toEqual([base, sameName]);

      // finally by id
      expect(billFilter([sameDescription, base])).toEqual([base, sameDescription]);
    });
  });
});
