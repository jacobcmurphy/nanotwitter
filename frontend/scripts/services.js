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
			$http.post(AUTH_ENDPOINT, { "username": user,
						    "password": pass })

			.success(function(data, status) {
				lastLoginFailed = false;
				userID = data['id'];
				$cookies["userID"] = userID;
				
			})
			.error(function() {
				lastLoginFailed = "Login error";
			});
		},

		createAccount: function(user, name, email, pass) {
			$http.post(CREATE_ENDPOINT, { "username" : user,
						      "name": name,
						      "email": email,
						      "password": pass })

			.success(function(data, status) {
				lastCreateFailed = false;
				lastLoginFailed = false;
				userID = data['id'];
			})
			.error(function () {
				lastCreateFailed = "Creation failure";
			});

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
			if (id in userInfo) {
				return userInfo[id];
			}
			return null;
		},

		updateCacheForUser: function (id) {
			$http.get(USER_ENDPOINT + id)
			.success(function (data) {
				userInfo[id] = data;
			});
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

		postTweet: function (userID, tweet) {
			$http.post(TWEET_ENDPOINT, {"user": userID,
						    "content": tweet });
		}
	};
}]);


ntServices.factory('follow', ['$http', function($http) {
	var followCache = {};

	return {
		addFollow: function (user, toFollow) {
			$http.post(FOLLOW_ENDPOINT + user, { followee_id: toFollow})
			.success(function (data) {
				console.log("Followed!");
				if (user in followCache) {
					followCache[user].push(toFollow);
					return;
				}

				followCache[user] = [toFollow];
				console.log(followCache);
			});
		},

		doesFollow: function(user, follows) {
			if (!(user in followCache)) {
				console.log("User not in cache!");
				return false;
			}


			return followCache[user] == follows || followCache[user].indexOf(follows) > -1;
		},

		getFollowers: function(user) {
			if (user in followCache) {
				return followCache[user];
			}
			return null;
		
		},

		updateCacheForFollow: function(user) {
			$http.get(FOLLOW_ENDPOINT + user)
			.success(function (data) {
				followCache[user] = data.followees;
			});
		},
	};
}]);
