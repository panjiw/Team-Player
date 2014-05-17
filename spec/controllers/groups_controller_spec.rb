#
# TeamPlayer -- 2014
#
# This file tests the GroupssController functionality 
#

require 'spec_helper'

describe GroupsController do

# create
	describe "testing CREATE" do
		
		# no param checks

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "newuser", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
        		 :password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        		 :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "test", :firstname => "Team", :lastname => "Player", :email => "test@player.com",
        		 :password => "player", :password_confirmation => "player"}
        	
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "takenname", :password => "player"}

        	@controller = GroupsController.new
			end

		it 'should create a group with one member' do
			post 'create', :group => {:name => "group name", :description => "desc"}
			# check information
			(response.status == 200).should be_true
			end

		it 'should create a group with two members' do
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1]}
			# check information
			(response.status == 200).should be_true
			end

		it 'should create a group with three members' do
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,3]}
			# check information
			(response.status == 200).should be_true
			end

		it 'should create a group with a member error since member doesnt exist' do
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [5]}
			# check information
			(response.status == 206).should be_true
			end

		end

# view members is not implemented- it's implemented in a different controller

# # viewmembers
# 	describe "testing VIEWMEMBERS" do

# 		before(:each) do
# 			@controller = UsersController.new
# 			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
#         		 :password => "player", :password_confirmation => "player"}
#         	post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "two@player.com",
#         		 :password => "player", :password_confirmation => "player"}				
			
# 			@controller = SessionsController.new
#         	post 'create', :user => {:username => "one", :password => "player"}

#         	@controller = GroupsController.new
#         	post 'create', :group => {:name => "group alone", :description => "desc"} 
# 			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2]}
# 		end

# 		# self group
# 		it 'should return the self group with one member' do
# 			puts "here"
# 			get 'viewmembers', :view => {:id => "1"}
# 			puts "done"
# 			# check descriptions

# 			(response.status == 200).should be_true
# 		end

# 		# group with one person not self group
# 		it 'should return the self group with one member' do
# 			get 'viewmembers', :view => {:id => "3"}
		
# 			(response.status == 200).should be_true
# 		end

# 		# group with two people
# 		it 'should return the self group with one member' do
# 			get 'viewmembers', :view => {:id => "4"}
		
# 			(response.status == 200).should be_true
# 		end

# 		# group does not exist
# 		it 'should return the self group with one member' do
# 			get 'viewmembers', :view => {:id => "5"}
		
# 			(response.status == 400).should be_true
# 		end

# 	end
	
# invitetogroup is implemented in a differet controller

# invitetogroup

# 

# destroy


end