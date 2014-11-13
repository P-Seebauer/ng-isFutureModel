// Karma configuration
// Generated on Tue Nov 11 2014 21:41:40 GMT+0100 (CET)

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['mocha', 'chai'],

    files: ["bower_components/angular/angular.js",
	    "bower_components/angular-resource/angular-resource.js",
	    "bower_components/angular-mocks/angular-mocks.js",
	    'src/*js', 'test/*coffee',
	   ],

    exclude: ['**/*~'],


    preprocessors: {
      '**/*.coffee': ['coffee']
    },


    reporters: ['mocha'],

    port: 9876,
    colors: true,

    logLevel: config.LOG_INFO,

    autoWatch: true,

    browsers: ['Chrome', 'PhantomJS'],

    singleRun: false
  });
};
