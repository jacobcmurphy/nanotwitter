class CreateUsers < ActiveRecord::Migration 
  def self.up
    create_table :users do |t| 
      t.string :username, :null=>false, :unique=>true
      t.string :email, :null=>false, :unique=>true
      t.string :password, :null=>false
      t.timestamps
    end
	add_index(:users, :password, name: "user_password_index")
end


def self.down 
  drop_table :users
end end
