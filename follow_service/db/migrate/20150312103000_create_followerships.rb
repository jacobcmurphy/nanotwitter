class CreateFollowerships < ActiveRecord::Migration
	def change
		create_table :followerships do |t|
			t.string :user_id
			t.integer :followee_id
			t.datetime :created_at
		end
	end
end
