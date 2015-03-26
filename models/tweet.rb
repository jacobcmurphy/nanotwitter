require 'active_record'

class Tweet < ActiveRecord::Base 
	belongs_to :user
	has_many :hashtags
end
