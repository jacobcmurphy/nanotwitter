require 'active_record'

class Followership < ActiveRecord::Base
	belongs_to :user
	belongs_to :followee, :class_name => 'User'
end
