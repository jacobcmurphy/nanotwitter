class User < ActiveRecord::Base 
  validates_uniqueness_of :username
  def to_json
    super(:except => :password)
  end 
end
