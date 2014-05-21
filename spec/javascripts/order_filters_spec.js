describe("Order filters tests", function() {
var userFilter;

beforeEach(function() {
  module("myapp");

  inject(function(_$filter_) {
    userFilter = _$filter_("orderUsers");
    expect(userFilter).toBeDefined();
  });
});

describe("user filter", function() {
  it("Empty object returns empty", function() {
    expect(userFilter({})).toEqual([]);
  });

  it("One returns just that", function() {
    var user = new User(1, "test", "Test", "Testman");
    var obj = {1: user};
    expect(userFilter(obj)).toEqual([user]);
  });

  it("Orders different usernames correctly", function() {
    var smaller = new User(2, "alpha", "Test", "Testman");
    var bigger = new User(1, "beta", "Test", "Testman");
    console.log(userFilter({1: bigger, 2: smaller}));
    expect(userFilter({1: bigger, 2: smaller})).toEqual([smaller, bigger]);
  });
});

});
