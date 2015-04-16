require 'active_record'

class User < ActiveRecord::Base
	has_many :followerships
	has_many :followers, :through => :followerships, :source => :user
	has_many :followees, :class_name => 'User', :through => :followerships,  :foreign_key => 'user_id'
	has_many :tweets

	validates_uniqueness_of :username

end
