var ntApp = angular.module('ntApp', ['ngRoute', 'ntControllers']);

ntApp.config(['$routeProvider',
	      function($routeProvider) {
		      $routeProvider.when('/login', {
			      templateUrl: 'partials/login.html',
			      controller: 'LoginCtrl'
		      }).when('/home', {
			      templateUrl: 'partials/home.html',
			      controller: 'HomeCtrl'
		      }).when('/splash', {
			      templateUrl: 'partials/splash.html',
			      controller: 'SplashCtrl'
		      }).when('/create', {
			      templateUrl: 'partials/create.html',
			      controller: 'CreateCtrl'
		      }).when('/user/:id', {
			      templateUrl: 'partials/user.html',
			      controller: 'UserCtrl'
		      }).otherwise({
			      redirectTo: '/splash'
		      });
	      }]);
 
