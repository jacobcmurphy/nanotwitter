class CreateTweets < ActiveRecord::Migration
	def change
		create_table :tweets do |t|
			t.string :text
			t.integer :user_id
			t.datetime :created_at
		end

#		add_index(:tweets, :user_id, name: 'tweet_uid_index')
#		add_index(:tweets, :created_at, name: 'tweet_created_index')
	end
end
