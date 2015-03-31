require 'csv'
require 'faker'
require_relative './../models/user'
require_relative './../models/tweet'
require_relative './../models/followership'

user_file = File.expand_path("../seed_data/users.csv", __FILE__)
tweet_file = File.expand_path("../seed_data/tweets.csv", __FILE__)
follow_file = File.expand_path("../seed_data/follows.csv", __FILE__)

puts "starting users"
user_list = []
CSV.foreach(user_file) do |user|
	user_list << User.new( name: user[1], username: "#{Faker::Internet.user_name+user[0]}", password: "pass", email: Faker::Internet.safe_email)
end
User.transaction do
	user_list.each do |user|
		user.save!
		puts user.errors if user.errors.any?
	end
end

puts "starting tweets"
tweet_list = []
CSV.foreach(tweet_file) do |tweet|
	tweet_list << Tweet.new(user_id: tweet[0], text: tweet[1], created_at: DateTime.parse(tweet[2]) )
end
Tweet.transaction do
	tweet_list.each do |tweet|
		tweet.save
	end
end

puts "starting followerships"
followership_list = []
CSV.foreach(follow_file) do |relation|
	followership_list << Followership.new(user_id: relation[0], followee_id: relation[1])
end
Followership.transaction do
	followership_list.each do |followership|
		followership.save
	end
end
