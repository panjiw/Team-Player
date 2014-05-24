#
# TeamPlayer -- 2014
#
# This file tests the GroupssController functionality 
#

require 'spec_helper'

#TODO: param checks

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

		# context 'user is not signed in' do

		# 	before(:each) do
		# 		@controller = SessionsController.new
		# 		delete 'destroy'
  #       		@controller = GroupsController.new
		# 		post 'create', :group => {:name => "group name", :description => "desc"}
		# 	end

		# 	it 'should redirect the user' do
		# 		(response.status == 302).should be_true
		# 	end

		# end

		context 'create a group with one member' do
			
			before(:each) do
				post 'create', :group => {:name => "group name", :description => "desc"}
			end
			
			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end
		
			it 'should have the correct group information' do
				groupinfo = "{\"id\":4,\"name\":\"group name\",\"description\":\"desc\",\"creator\":2"
				(response.body.include? groupinfo).should be_true
			end

			it 'should have the correct member information' do
				userinfo = "\"users\":[{\"id\":2,\"username\":\"takenname\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"team@player.com\""
				(response.body.include? userinfo).should be_true
			end

		end

		context 'create a group with two members' do
			
			before(:each) do
				post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1]}
			end
			
			it 'should return a 200 statys' do
				(response.status == 200).should be_true
			end
		
			it 'should have the correct group information' do
				groupinfo = "{\"id\":4,\"name\":\"group name\",\"description\":\"desc\",\"creator\":2"
				(response.body.include? groupinfo).should be_true
			end

			it 'should have the first member information' do
				userinfoone = "\"users\":[{\"id\":2,\"username\":\"takenname\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"team@player.com\""
				(response.body.include? userinfoone).should be_true
			end

			it 'should include the second member information' do
				userinfotwo = "\"id\":1,\"username\":\"newuser\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"new@player.com\""
				(response.body.include? userinfotwo).should be_true
			end

		end

		it 'should create a group with three members' do
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,3]}
			(response.status == 200).should be_true
			end

		it 'should create a group with a member error since member doesnt exist' do
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [5]}
			(response.status == 206).should be_true
			end

		end

  # edit group, given the following params, this will change the 
  # require user to be logined, and creator of the group
  # editgroup[id]: group to be edited
  # editgroup[name]: new name or same name for this group
  # editgroup[description]: new description
  # 
  # Returns the the group changed info
  #  
  # return the new group and all the users in this group
  # look at (creategroup) above for return details

	# edit group
	describe 'testing EDIT' do

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
        	post 'create', :group => {:name => "group name", :description => "desc"}
			end

		# edit name
		context 'editting the group name' do

			before(:each) do
			post 'editgroup', :editgroup => {:id => 1, :name => "new name", :description => "desc"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct group information' do
				groupinfo = "{\"id\":1,\"name\":\"new name\",\"description\":\"desc\",\"creator\":1"
				(response.body.include? groupinfo).should be_true
			end

			it 'should have the correct member information' do
				userinfo = "\"users\":[{\"id\":1,\"username\":\"newuser\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"new@player.com\""
				(response.body.include? userinfo).should be_true
			end

		end

		# edit description
		context 'editting the group name' do

			before(:each) do
				post 'editgroup', :editgroup => {:id => 1, :name => "group name", :description => "new desc"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct group information' do
				groupinfo = "{\"id\":1,\"name\":\"group name\",\"description\":\"new desc\",\"creator\":1"
				(response.body.include? groupinfo).should be_true
			end

			it 'should have the correct member information' do
				userinfo = "\"users\":[{\"id\":1,\"username\":\"newuser\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"new@player.com\""
				(response.body.include? userinfo).should be_true
			end

		end

		# edit description to null
		context 'edditing description to null' do

			before(:each) do
				post 'editgroup', :editgroup => {:id => 1, :name => "group name", :description => nil}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		# edit title to null
		context 'edditing title to null' do

			before(:each) do
				post 'editgroup', :editgroup => {:id => 1, :name => nil, :description => "new desc"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		# nothing changed
		context 'no changes are made' do

			before(:each) do
				post 'editgroup', :editgroup => {:id => 1, :name => "group name", :description => "desc"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct group information' do
				groupinfo = "{\"id\":1,\"name\":\"group name\",\"description\":\"desc\",\"creator\":1"
				(response.body.include? groupinfo).should be_true
			end

			it 'should have the correct member information' do
				userinfo = "\"users\":[{\"id\":1,\"username\":\"newuser\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"new@player.com\""
				(response.body.include? userinfo).should be_true
			end

		end

	end

	# # leave group
	describe 'testing LEAVEGROUP' do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
        		 :password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        		 :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "three", :firstname => "Team", :lastname => "Player", :email => "test@player.com",
        		 :password => "player", :password_confirmation => "player"}
        	
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "takenname", :password => "player"}

        	@controller = GroupsController.new
        	post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2,3]}

		end


	end

	# invitetogroup
	describe 'testing INVITETOGROUP' do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
        		 :password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        		 :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "three", :firstname => "Team", :lastname => "Player", :email => "test@player.com",
        		 :password => "player", :password_confirmation => "player"}
        	
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "one", :password => "player"}

        	@controller = GroupsController.new
        	post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2]}
		end

		describe 'the user is not signed in' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "test@player.com",:gid => 4}
			end

			it 'should throw an error' do
				(response.status == 400).should be_true
			end

		end

		#tring to add to self group
		describe 'should invite the member to the group' do

			before(:each) do
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "test@player.com",:gid => 1}
			end

			it 'should return status 400' do
				(response.status == 400).should be_true
			end

			# check

		end

		describe 'should invite the member to the group' do

			before(:each) do
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "test@player.com",:gid => 4}
			end

			it 'should return status 200' do
				(response.status == 200).should be_true
			end

			# check

		end

		# user is already in group
		describe 'should invite the member to the group' do

			before(:each) do
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "team@player.com",:gid => 4}
			end

			it 'should return status 400' do
				(response.status == 400).should be_true
			end

			# check

		end

		# user does not exist
		describe 'should user does not exist' do

			before(:each) do
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "hahahaha@player.com",:gid => 4}
			end

			it 'should return status 400' do
				(response.status == 400).should be_true
			end

			# check

		end

	end

	# accept group
	describe 'testing ACCEPTGROUP' do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
        		 :password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        		 :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "three", :firstname => "Team", :lastname => "Player", :email => "test@player.com",
        		 :password => "player", :password_confirmation => "player"}
        	
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "one", :password => "player"}

        	@controller = GroupsController.new
        	post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2]}
        	post 'invitetogroup', :invite => {:email => "test@player.com",:gid => 4}
		
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "three", :password => "player"}

        	@controller = GroupsController.new
        	
		end

		describe 'missing parameters' do

			before(:each) do
				post 'acceptgroup'
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		describe 'accepts to group' do

			before(:each) do
				post 'acceptgroup', :accept => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

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


end