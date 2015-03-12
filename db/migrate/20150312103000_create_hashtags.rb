class CreateHashtags < ActiveRecord::Migration
	def up
		create_table :hashtags do |t|
			t.string :tag
			t.integer :tweet_id
			t.datetime :created_at
		end
	end

	def down
		drop_table :hashtags
	end
end
