describe('Login', function() {
  var ptor;
  beforeEach(function() {
    browser.get('http://localhost:4000/');
    ptor = protractor.getInstance();
  });

  it('should redirect you to / if you are not logged in', function() {
    expect(browser).toBeDefined();

    browser.get("/");
    expect(browser.getCurrentUrl()).toEqual("/");
    
    browser.get("/home");
    expect(browser.getCurrentUrl()).toEqual("/");
    
    browser.get("/hsdflksdflkjome");
    expect(browser.getCurrentUrl()).toEqual("/");
  });

  it("should assert true", function() {
    expect(true).toBe(true);
  });
});
