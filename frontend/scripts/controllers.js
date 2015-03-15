var ntControllers = angular.module('ntControllers', ['ntServices']);

ntControllers.controller('LoginCtrl', ['$scope', 'auth', '$location', 
       function($scope, auth, $location) {
	       $scope.error = false;

	       $scope.$watch(auth.didLastLoginFail, function (e) {
		       $scope.error = e;
	       });


	       $scope.$watch(auth.isLoggedIn, function (v) {
		       if (v) {
			       // redirect to the homepage
			       $location.path("#/home");
		       }
	       });

	       
	       $scope.doLogin = function () {
		       auth.attemptLogin($scope.username, $scope.password);
	       };
       }]);



ntControllers.controller('CreateCtrl', ['$scope', 'auth', '$location',
      function ($scope, auth, $location) {
	      $scope.error = false;

	      $scope.$watch(auth.didLastCreateFail, function (e) {
		       $scope.error = e;
	       });

	      $scope.create = function () {
		      if ($scope.password != $scope.confirm) {
			      $scope.error = "Passwords must match";
			      return;
		      };

		      auth.createAccount($scope.username, 
					 $scope.name,
					 $scope.email,
					 $scope.password);
	      };

	       $scope.$watch(auth.isLoggedIn, function (v) {
		       if (v) {
			       // redirect to the homepage
			       $location.path("#/home");
		       }
	       });
      }]);

ntControllers.controller('SplashCtrl', ['$scope', 'tweet',
       function($scope, tweet) {
	       $scope.mostRecent = tweet.getMostRecent();
	       tweet.updateMostRecent();

	       $scope.$watch(tweet.getMostRecent, function () {
		       $scope.mostRecent = tweet.getMostRecent();
	       });
	       
       }]);

ntControllers.controller('UserCtrl', ['$scope', 'user', 'auth', 'follow', '$routeParams',
      function ($scope, user, auth, follow, $routeParams) {
	      $scope.userID = $routeParams.id;
	      $scope.userInfo = {};

	      user.updateCacheForUser($scope.userID);
	      follow.updateCacheForFollow($scope.userID);

	      $scope.$watch(function () { return user.getUser($scope.userID); },
			    function () { 
				    $scope.userInfo = user.getUser($scope.userID); 
			    });

	      $scope.canFollow = auth.isLoggedIn();

	      $scope.follow = function () {
		      follow.addFollow(auth.getUserID(), $scope.userID);
	      };

	      $scope.$watch(function () { 
		      return follow.doesFollow(auth.getUserID(), $scope.userID); 
	      }, function () {
		      $scope.canFollow = 
			      auth.isLoggedIn() 
			      && (!follow.doesFollow(auth.getUserID(), $scope.userID));
	      });

      }]);

ntControllers.controller('HomeCtrl', ['$scope', 'auth', 'user', 'follow', 'tweet',
      function ($scope, auth, user, follow, tweet) {
	      $scope.userID = auth.getUserID();
	      $scope.followees = follow.getFollowers($scope.userID);
	      
	      console.log("In ctrl! " + $scope.userID);

	      $scope.$watch(function () {
		      return follow.getFollowers($scope.userID);
	      }, function () {
		      $scope.followees = follow.getFollowers($scope.userID);
		      console.log($scope.followees);
	      });

	      follow.updateCacheForFollow($scope.userID);

	      $scope.submitTweet = function () {
		      tweet.postTweet($scope.userID, $scope.tweet);
	      };
      }]);