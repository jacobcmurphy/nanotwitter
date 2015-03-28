class CreateHashtags < ActiveRecord::Migration
	def up
		create_table :hashtags do |t|
			t.string :tag
			t.integer :tweet_id
			t.datetime :created_at
		end

		add_index(:hashtags, :tweet_id, name: "hashtag_tweetid_index")
	end

	def down
		drop_table :hashtags
	end
end
