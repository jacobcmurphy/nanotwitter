require 'active_record'

class Hashtag < ActiveRecord::Base
	belongs_to :tweet
end
