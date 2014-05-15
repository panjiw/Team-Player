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
    	it 'should add one user' do
			@user.should be_valid
		end
	end	

end
	
# tests than, when attempting to create an invalid user, throws an error
describe "adding an incorrect user" do
	
    context 'creating mismatching passwords user' do
    	it 'should throw an error' do
    		lambda { User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "notworking" }.should raise_error
		end
	end	

    context 'creating too short password user' do
        it 'should throw an error' do
            lambda { User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "no", :password_confirmation => "no" }.should raise_error
        end
    end 

    context 'email already in database' do
        it 'should throw an error' do
        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
        lambda { User.create! :username => "newname", :firstname => "New", :lastname => "Name", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"}.should raise_error
        end
    end

    context 'username already in database' do
        it 'should throw an error' do
        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
        lambda { User.create! :username => "teamplayer", :firstname => "New", :lastname => "Name", :email => "new@email.com",
                            :password => "player", :password_confirmation => "player"}.should raise_error
        end
    end

end

# tests the controller's create method
describe "CREATE new" do
    before(:each) do

        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "player"
        
    end

    # tests when every value is correct that create works
    context 'should create user' do
        it 'should be ok ' do
            post 'create', :user => {:username => "newusername", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "player", :password_confirmation => "player"}
           #response.body.should_be_valid token:
            (response.body.include? "token").should be_true
            #value.should_be true
        end
    end

    # test when username is already in database that create does not work
    context 'should not create user' do
        it 'should not be ok ' do
            post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "no@player.com",
                             :password => "player", :password_confirmation => "player"}
            (response.body.include? "error").should be_true
            #(respone.body.include? "Username has already been taken").should be_true
        end 
    end

    # tests when email is already in database that create does not work
    context 'should not create user' do
        it 'should not be ok ' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                             :password => "player", :password_confirmation => "player"}
            (response.body.include? "error").should be_true
            #(respone.body.include? "Email has already been taken").should be_true
        end 
    end

    # tests when password size is not long enough that create does not work
    context 'should not create user' do
        it 'should not be ok ' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "play", :password_confirmation => "play"}
            (response.body.include? "error").should be_true
            #(respone.body.include? "Email has already been taken").should be_true
        end 
    end

    # tests when passwords do not match create does not work
    context 'should not create user' do
        it 'should not be ok ' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "playrrrrrrr", :password_confirmation => "playeeeee"}
            (response.body.include? "error").should be_true
            #(respone.body.include? "Email has already been taken").should be_true
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