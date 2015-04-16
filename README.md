# nanotwitter
[![Code Climate](https://codeclimate.com/github/jacobcmurphy/nanotwitter/badges/gpa.svg)](https://codeclimate.com/github/jacobcmurphy/nanotwitter)

Initalize database: ``rake db:migrate``
Seed data: ``rake db:seed``
Run: ``rackup``


Endpoints:

Required by assignment:
/
	return homepage - 100 recent tweets if not logged in,
					100 recent of followers if logged in
/login
	returns JSON saying login worked or failed	
/logout
	does nothing, refreshes page
/user/register
	returns JSON based on ability to create the new user
/user/:id
	returns page with list of user's tweets, button to follow user if logged in, if your page, a tweet box
/user/profile
	returns page of logged in user with name, email, and list of followers; if not logged in, redirects back to /login
/tweet (post)
	creates tweet and redirects back to last page
/api/v1/tweets/:id
	JSON of tweet
/api/v1/tweets/recent
	JSON of 100 most recent tweets
/api/v1/users/:id
	JSON of user information
/api/v1/users/:id/tweets
	JSON of user's 100 most recent tweet 


ours:
/api/v1/users/:id/feed
	JSON of user's follower's 100 most recent tweets
/api/v1/users/:id/following
	JSON array of users that user follows
/api/v1/users/:id/followers (get, post, delete)
	add or remove a following
	JSON array of followers for user
