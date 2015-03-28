require 'csv'
require 'faker'
require_relative './../models/user'
require_relative './../models/tweet'
require_relative './../models/followership'

user_file = File.expand_path("../seed_data/new_users.csv", __FILE__)
tweet_file = File.expand_path("../seed_data/new_tweets.csv", __FILE__)
follow_file = File.expand_path("../seed_data/new_follows.csv", __FILE__)

CSV.foreach(user_file) do |user|
	User.create(id: user[0], name: user[1], username: Faker::Internet.user_name, password: "pass", email: Faker::Internet.safe_email)
end

puts "starting tweets"

CSV.foreach(tweet_file) do |tweet|
	Tweet.create(user_id: tweet[0], text: tweet[1], created_at: DateTime.parse(tweet[2]) )
end

puts "starting followerships"

CSV.foreach(follow_file) do |relation|
	Followership.create(user_id: relation[0], followee_id: relation[1])
end
