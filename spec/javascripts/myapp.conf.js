module.exports = function(config) {
  config.set({
    basePath: '../..',

    frameworks: ['jasmine'],

    autoWatch: true,

    browsers: ['PhantomJS'],

    plugins: [
            'karma-phantomjs-launcher'
        ],
    
    files: [
      'app/assets/javascripts/angular.js',
      'app/assets/javascripts/angular-mocks.js',
      'app/assets/javascripts/main.js',
      'app/assets/javascripts/users/usermodel.js',
      'app/assets/javascripts/controllers/loginViewController.js',
      'spec/javascripts/*_spec.js'
    ]  
  });
};
