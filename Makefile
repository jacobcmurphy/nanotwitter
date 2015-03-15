
.phony: test migrate
test:
	cd user_service && rake test
	cd follow_service && rake test
	cd hashtag_service && rake test
	cd tweet_service && rake app:test

migrate:
	cd user_service && bundle install && rake db:migrate
	cd tweet_service && bundle install && rake db:drop && rake db:migrate
	cd hashtag_service && bundle install && rake db:migrate
	cd follow_service && bundle install && rake db:migrate
