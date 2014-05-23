#
# TeamPlayer -- 2014
#
# This file tests the SessionsController functionality 
#

require 'spec_helper'

describe SessionsController do

# create
context 'logining in the user' do
    
    context 'correct information is given' do
       		
            before(:each) do
                @controller = UsersController.new
    			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                	 :password => "player", :password_confirmation => "player"}
                
                @controller = SessionsController.new
                post 'create', :user => {:username => "takenname", :password => "player"}
            end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end
        end

    # username does not exist
    context 'username does not exist' do
    		
            before(:each) do
            post 'create', :user => {:username => "takenname", :password => "player"}
        	end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
    	   end
        end

    # password does not match usernamee
    it 'password does not match should sned a 400 status' do
    	    @controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            	 :password => "player", :password_confirmation => "player"}
            
            @controller = SessionsController.new
            post 'create', :user => {:username => "takenname", :password => "nottherightpassword"}

            (response.status = 400).should be_true
		end

	end

context 'presenting user data' do

	# it should present the correct user data because the user is logged in
	context 'the user is logged in' do
			
        before(:each) do
            @controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            	 :password => "player", :password_confirmation => "player"}
            
            @controller = SessionsController.new
            post 'create', :user => {:username => "takenname", :password => "player"}

            get 'user'
        end

        it 'should return a 200 status' do
            (response.status == 200).should be_true
            end

        it 'should return the correct information' do
            userinfo = "{\"username\":\"takenname\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"id\":1"
            (response.body.include? userinfo).should be_true
        end
		end

	# it should not present user data because the user is not logged in
	it 'should not present user information because user is not logged in' do
			get 'user'
			(response.body.include? "redirected").should be_true
		end

	end

# destroy
context 'loging out the user' do

	it 'should logout the user' do
		@controller = UsersController.new
		post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            
        @controller = SessionsController.new
           post 'create', :user => {:username => "takenname", :password => "player"}

        delete 'destroy'
        get 'user'
        (response.body.include? "redirected").should be_true

	end

	# not sure if should be implemented - the case never exists where a user can feasibly log out while 
	# not being logged in.
	it 'should not logout the user because no user is logged in' do
		# delete 'destroy'
  #       get 'user'
  #       (response.body.include? "redirected").should be_true
	end
end

end