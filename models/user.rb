require 'active_record'

class User < ActiveRecord::Base 
	has_many :followers, :class_name => 'Followership', :foreign_key => 'user_id'
	has_many :followees, :class_name => 'Followership', :foreign_key => 'followee_id'
	has_many :tweets


  validates_uniqueness_of :username

  def to_json
    super(:except => :password)
  end 
end
