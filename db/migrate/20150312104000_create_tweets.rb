class CreateTweets < ActiveRecord::Migration
	def change
		create_table :tweets do |t|
			t.string :text
			t.string :user_id
			t.datetime :created_at
		end

		add_index(:tweets, :user_id, name: 'tweet_uid_index')
	end
end
