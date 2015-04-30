#require_relative './../routes/followership_routes.rb'
require 'minitest/autorun'
#require 'rack/test'

describe "service" do
	# include Rack::Test::Methods
	#
	# def app
	# 	FollowershipRoutes
	# end


	before do
		#Followership.delete_all
	end

	describe "GET on /followerships" do
		# before do
		# 		Followership.create(user_id: 1, followee_id: 2)
		# 		Followership.create(user_id: 1, followee_id: 3)
		# end

		it "should be fine" do
			"1".must_equal "1"
		end
	end

end
