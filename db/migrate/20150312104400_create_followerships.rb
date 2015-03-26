class CreateFollowerships < ActiveRecord::Migration
	def change
		create_table :followerships do |t|
			t.string :user_id
			t.integer :followee_id
			t.datetime :created_at
		end

		add_index(:followerships, [:user_id, :followee_id], unique: true, name: 'stop_double_following')
	end
end
