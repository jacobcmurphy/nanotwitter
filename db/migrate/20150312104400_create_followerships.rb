class CreateFollowerships < ActiveRecord::Migration
	def change
		create_table :followerships do |t|
			t.integer :user_id
			t.integer :followee_id
			t.datetime :created_at
		end

		add_index(:followerships, :user_id, name: 'stop_double_following')
	end
end
