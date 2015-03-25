var ntControllers = angular.module('ntControllers', ['ntServices']);

ntControllers.controller('LoginCtrl', ['$scope', 'auth', '$location', 
       function($scope, auth, $location) {
	       $scope.error = false;

	       $scope.$watch(auth.didLastLoginFail, function (e) {
		       $scope.error = e;
	       });


	       $scope.$watch(auth.isLoggedIn, function () {
		       if (auth.isLoggedIn()) {
			       // redirect to the homepage
			       console.log("Going to home!");
			       $location.path("/home");
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

	      user.getUser($scope.userID).then(function (d) {
		      $scope.userInfo = d;
		      $scope.$apply();
	      });

	      $scope.canFollow = false;
	      follow.doesFollow(auth.getUserID(), $scope.userID).then(function (r) {
		      console.log("Follow result: " + r);
		      $scope.canFollow = !r;
		      $scope.$apply();
	      });
		 
	      $scope.follow = function () {
		      follow.addFollow(auth.getUserID(), $scope.userID);
	      };

	     

      }]);

ntControllers.controller('HomeCtrl', ['$scope', 'auth', 'user', 'follow', 'tweet',
      function ($scope, auth, user, follow, tweet) {
	      $scope.userID = auth.getUserID();

	      follow.getFollowers($scope.userID).then(function (f) {
		      $scope.followees = f;
	      });

	      console.log("Followers: " + $scope.followees);
	      $scope.tweets = [];


	      follow.getFollowers($scope.userID).then(function (f) {
		      $scope.followees = f;
		      return tweet.getTweetsForUsers($scope.followees);
	      }).then(function (d) {
		      console.log("got tweets! " + JSON.stringify(d));
		      $scope.tweets = d;
		      $scope.$apply();
	      });


	      $scope.submitTweet = function () {
		      tweet.postTweet($scope.userID, $scope.tweet)
		      .then(function () {
			      $scope.tweets.unshift({"user_id": $scope.userID,
						     "content": $scope.tweet,
						     "created_at": new Date()});
			      $scope.tweet = "";
			      $scope.$apply();
		      });
	      };


      }]);
