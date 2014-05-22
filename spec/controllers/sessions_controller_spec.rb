#
# TeamPlayer -- 2014
#
# This file tests the SessionsController functionality 
#

require 'spec_helper'

describe SessionsController do

# create
context 'logining in the user' do
    
    it 'should login the user' do
       		@controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            	 :password => "player", :password_confirmation => "player"}
            
            @controller = SessionsController.new
            post 'create', :user => {:username => "takenname", :password => "player"}

            (response.status == 200).should be_true
        end

    # username does not exist
    it 'should not login the user becuase username does not exist' do
    		post 'create', :user => {:username => "takenname", :password => "player"}
        	(response.status == 400).should be_true
    	end

    # password does not match usernamee
    it 'should not login the user because password does not match' do
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
	it 'should present user information' do
			@controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            	 :password => "player", :password_confirmation => "player"}
            
            @controller = SessionsController.new
            post 'create', :user => {:username => "takenname", :password => "player"}

            get 'user'
            (response.body.include? "takenname").should be_true
            (response.body.include? "1").should be_true
            (response.body.include? "Player").should be_true
            (response.body.include? "Team").should be_true
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