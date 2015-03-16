var ntServices = angular.module('ntServices', ['ngCookies']);

ntServices.factory('auth', ['$http', '$cookies', function($http, $cookies) {
	var userID = null;
	var lastLoginFailed = false;
	var lastCreateFailed = false;

	return {
		isLoggedIn: function () { 
			if (userID != null)
				return true;

			// check the cookie
			var saved = $cookies["userID"];
			if (saved != "" && saved) {
				userID = saved;
				return true;
			}

			return false;
		},
		getUserID: function () { 
			var saved = $cookies["userID"];
			if (saved != "" && saved) {
				userID = saved;
			}

			return userID; 
		},

		attemptLogin: function(user, pass) {
			var toR = Q.defer();

			$http.post(AUTH_ENDPOINT, { "username": user,
						    "password": pass })

			.success(function(data, status) {
				lastLoginFailed = false;
				userID = data['id'];
				$cookies["userID"] = userID;
				toR.resolve();
				
			})
			.error(function() {
				toR.reject();
				lastLoginFailed = "Login error";
			});

			return toR.promise;
		},

		createAccount: function(user, name, email, pass) {
			var toR = Q.defer();

			$http.post(CREATE_ENDPOINT, { "username" : user,
						      "name": name,
						      "email": email,
						      "password": pass })

			.success(function(data, status) {
				lastCreateFailed = false;
				lastLoginFailed = false;
				userID = data['id'];
				toR.resolve();
			})
			.error(function () {
				lastCreateFailed = "Creation failure";
				toR.reject();
			});

			return toR.promise;

		},

		logout: function () { userID = null; },
		didLastLoginFail: function () { return lastLoginFailed; },
		didLastCreateFail: function () { return lastCreateFailed; }
	};
}]);

ntServices.factory('user', ['$http', function($http) {
	var userInfo = {};
	
	return {
		getUser: function (id) {
			var toR = Q.defer();
			if (id in userInfo) {
				toR.resolve(userInfo[id]);
			} else {
				$http.get(USER_ENDPOINT + id)
				.success(function (data) {
					userInfo[id] = data;
					toR.resolve(userInfo[id]);
				});	
			}
			
			return toR.promise;
		}

	};
}]);

ntServices.factory('tweet', ['$http', function($http) {
	var mostRecentTweets = [];
	


	return {
		updateMostRecent: function () {
			$http.get(MOST_RECENT_ENDPOINT)
			.success(function (data) {
				mostRecentTweets = data;
			});
		},

		getMostRecent: function () {
			return mostRecentTweets;
		},

		getTweetsForUsers: function(userList) {
			console.log("Getting tweets");
			var toR = Q.defer();
			$http.post(TWEETS_FOR_ENDPOINT,
				   {users: userList})
			.success(function (data) {
				console.log("Got response: " + JSON.stringify(data));
				toR.resolve(data);
			});

			return toR.promise;
		},

		postTweet: function (userID, tweet) {
			var toR = Q.defer();
			console.log("Posting tweet: " + tweet + " by " + userID);
			$http.post(TWEET_ENDPOINT, {"user_id": parseInt(userID),
						    "content": tweet })
			.success(function() {
				toR.resolve();
			});

			return toR.promise;
		}
	};
}]);


ntServices.factory('follow', ['$http', function($http) {
	var followCache = {};

	return {
		addFollow: function (user, toFollow) {
			console.log("Making " + user + " follow " + toFollow);
			$http.post(FOLLOW_ENDPOINT + user, { followee_id: toFollow})
			.success(function (data) {
				console.log("Valid response for follow!");
				if (user in followCache) {
					followCache[user].push(toFollow);
					return;
				}

				followCache[user] = [toFollow];
			});
		},

		doesFollow: function(user, follows) {
			var toR = Q.defer();
			
			
			$http.get(FOLLOW_ENDPOINT + user)
			.success(function (data) {
				follows = parseInt(follows);
				followCache[user] = data.followees;
				console.log(followCache[user]);
				console.log(follows + " idx " + followCache[user].indexOf(follows));
				toR.resolve(followCache[user] == follows 
					    || followCache[user].indexOf(follows) > -1);
			})
			.error(function () {
				toR.resolve(false);
			});
			
			return toR.promise;
		},

		getFollowers: function(user) {
			var toR = Q.defer();

			if (user in followCache) {
				toR.resolve(followCache[user]);
				return toR.promise;
			}

			$http.get(FOLLOW_ENDPOINT + user)
			.success(function (data) {
				followCache[user] = data.followees;
				toR.resolve(followCache[user]);
			});

			return toR.promise;
		
		}


	};
}]);
