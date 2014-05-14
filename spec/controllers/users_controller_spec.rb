#
# TeamPlayer -- 2014
#
# This file tests the UsersController functionality 
#

require 'spec_helper'

describe UsersController do
#itegrate_views


# tests if creates a valid user
describe "GET show" do
    before(:each) do
      @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
    end

    context 'creating one user' do
    	puts 'here'
    	it 'should add one user' do
			@user.should be_valid
		end
	end	

end
	

# tests than, when attempting to create a user with an invalid password, throws an error
describe "adding incorrect user" do
	context 'creating one user' do
    	it 'should not add one user' do
    		lambda { User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "notworking" }.should raise_error
		end
	end	

end
	





# # 
# before do
#   @user = [
#     User.new(username: "teamplayer", firstname: "Team", lastname: "Player", email: "team@player.com",
#                             password: "player", password_confirmation: "player")
#     #User.new(username: "tp", firstname: "toilet", lastname: "paper", email: "toilet@paper.com",
#    #                         password: "papers", password_confirmation: "papers")
#   ]
# end

# describe "GET signed_in_user"




# context 'fetching user information' do

#   subject do
#     puts here
#     get 'user.json'
#     puts JSON.parse(response.body)
  
#   end

#   it 'should return a correct user information' do
#     should == [
#       {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
#                             :password => "player", :password_confirmation => "player"}
#      # {:name => 'Bob', :login => 'bob'}
#     ]
#   end

# end


# context 'creating a new user' do
# 	it 'should add one user' do
#         lambda {
#           #post '//users.json', :user => {:name => 'Charlie', :login => 'charlie'}
#    		  post '/users.json',:user=> {:username => "tester", :firstname => "testing", :lastname => "testingln", :email => "tester@paper.com",
#                             :password => "papers", :password_confirmation => "papers"}
#        }.should change(User, :count).by(0)
# 	end
# end



end