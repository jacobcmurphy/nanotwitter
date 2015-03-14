require File.dirname(__FILE__) + '/../service' 
require 'rspec'
require 'test/unit'
require 'rack/test'


set :environment, :test 

def app 
  Sinatra::Application
end

describe "service" do 
  include Rack::Test::Methods

  before(:each) do
    User.delete_all
  end

  describe "GET on /api/v1/users/:id" do 
    let!(:user_id) { 
      User.create(:name => "paul",
                  :username => "PaulU",
                  :email => "paul@pauldix.net", 
                  :password => "strongpass").id
      }


    
    it "should return a user by id" do
      get '/api/v1/users/' + user_id.to_s
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body) 
      expect(attributes["name"]).to eq("paul")
      expect(attributes["username"]).to eq("PaulU")
    end

    it "should not return a user with an email" do
      get '/api/v1/users/' + user_id.to_s
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body) 
      expect(attributes).not_to have_key("email")
    end

    it "should not return a user's password" do 
      get '/api/v1/users/' + user_id.to_s 
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body) 
      expect(attributes).not_to have_key("password")
    end

    it "should return a 404 for a user that doesn't exist" do 
      get '/api/v1/users/12342356' 
      expect(last_response.status).to eq(404)
    end 
  end


  describe "POST on /api/v1/users" do 
    it "should create a user" do
      post('/api/v1/users', 
           { :name => "trotter",
             :username => "trotterU",
             :email => "no spam",
             :password => "whatever"}.to_json)

      expect(last_response).to be_ok
      user_id = JSON.parse(last_response.body)["id"]
      get '/api/v1/users/' + user_id.to_s
      attributes = JSON.parse(last_response.body) 
      expect(attributes["name"]).to eq("trotter")
      expect(attributes["username"]).to eq("trotterU")

    end 
  end


  describe "POST on /api/v1/users/login" do 
    before(:each) do
      User.create(:name => "josh",
                  :username => "JoshU",
                  :password => "testpass") 
    end
    
    it "should return the user object on valid credentials" do 
      post('/api/v1/users/login', 
           { :username => "JoshU",
             :password => "testpass"}.to_json )

      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body) 
      expect(attributes["name"]).to eq("josh")
    end

    it "should fail on invalid credentials" do 
      post('/api/v1/users/login', 
           { :username => "JoshU",
             :password => "badpass"}.to_json )
      
      expect(last_response.status).to eq(400)
    end 
  end  
end

