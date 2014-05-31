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

		context 'user is not signed in' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
        		@controller = GroupsController.new
				post 'create', :group => {:name => "group name", :description => "desc"}
			end

			it 'should redirect the user' do
				(response.status == 302).should be_true
			end

		end

		context 'name is null' do

			before(:each) do
				post 'create', :group => {:name => nil, :description => "desc"}
			end

			it 'should return a 400s tatus' do
				(response.status == 400).should be_true
			end

		end

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

		context 'trying to edit name to null' do

			before(:each) do
				post 'editgroup', :editgroup => {:id => 1, :name => nil, :description => "desc"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

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

	# leave group
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
        	post 'create', :user => {:username => "one", :password => "player"}

        	@controller = GroupsController.new
        	post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2]}
        	post 'create', :group => {:name => "name", :description => "desc"}, :add => {:members => [1]}
	
        	@controller = SessionsController.new
        	delete 'destroy'
        	post 'create', :user => {:username => "two", :password => "player"}

        	@controller = GroupsController.new
        	post 'acceptgroup', :accept => {:id => 4}

        	@controller = SessionsController.new
        	delete 'destroy'
        	post 'create', :user => {:username => "one", :password => "player"}
		end

		context 'params incorrect' do
			
			before(:each) do
				@controller = GroupsController.new
				post 'leavegroup'
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

			it 'should return the correct error' do
				errormessage = "Group Not Selected"
				(response.body.include? errormessage).should be_true
			end

		end

		context 'user not in group' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
        		post 'create', :user => {:username => "three", :password => "player"}
        		@controller = GroupsController.new
        		post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

			it 'should return the correct error' do
				errormessage = "Unable to leave group group name"
				(response.body.include? errormessage).should be_true
			end

		end

		context 'trying to leave self group' do

			before(:each) do
        		@controller = GroupsController.new
        		post 'leavegroup', :leave => {:id => 1}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

			it 'should return the correct error' do
				errormessage = "Unable to leave the 'Me' group"
				(response.body.include? errormessage).should be_true
			end

		end

		context 'leaves group and destroys group' do

			before(:each) do
				@controller = GroupsController.new
        		post 'leavegroup', :leave => {:id => 5}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

		end

		context 'successfully leaves group' do

			before(:each) do
        		@controller = GroupsController.new
        		post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

		end

		# leave group removes bill entirely
		context 'deleting bill information when leaving the group' do

			before(:each) do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 4, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
					:description => "desc", :due_date => "2014-05-17"}
				@controller = GroupsController.new
				post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should delete the bill for the user' do
				@controller = BillsController.new
				get 'get_all'
				(response.body.include? "{}").should be_true
			end

		end

		# leave group removes bill information
		context 'deleting bill information when leaving the group' do

			before(:each) do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 4, :title => "testing title", :total_due => 30, :members => {"1" => 10, "2" => 20}, 
					:description => "desc", :due_date => "2014-05-17"}
				@controller = GroupsController.new
				post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should delete the bill for the user' do
				@controller = BillsController.new
				get 'get_all'
				(response.body.include? "{}").should be_true
			end

		end

		# leave group removes task information
		context 'deleting task information when leaving the group' do

			before(:each) do
				@controller = TasksController.new
          		post 'new', :task => {:group_id => "4", :title => "title", :finished => false, :members => [1,2]}
				@controller = GroupsController.new
				post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should delete the bill for the user' do
				@controller = TasksController.new
				get 'get_all'
				(response.body.include? "{}").should be_true
			end

		end


		# leave group removes task entirely
		context 'deleting task information when leaving the group' do

			before(:each) do
				@controller = TasksController.new
          		post 'new', :task => {:group_id => "4", :title => "title", :finished => false, :members => [1]}
				@controller = GroupsController.new
				post 'leavegroup', :leave => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should delete the bill for the user' do
				@controller = TasksController.new
				get 'get_all'
				(response.body.include? "{}").should be_true
			end

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
				(response.status == 302).should be_true
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

			it 'should return the correct error' do
				errormessage = "Can not add to self group"
				(response.body.include? errormessage).should be_true
			end

		end

		describe 'should invite the member to the group' do

			before(:each) do
				@controller = GroupsController.new
				post 'invitetogroup', :invite => {:email => "test@player.com",:gid => 4}
			end

			it 'should return status 200' do
				(response.status == 200).should be_true
			end

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

			it 'should return the correct error' do
				errormessage = "User already in group"
				(response.body.include? errormessage).should be_true
			end

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

			it 'should return the correct error' do
				errormessage = "User not found"
				(response.body.include? errormessage).should be_true
			end

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

			it 'should return the correct error' do
				errormessage = "Missing Params"
				(response.body.include? errormessage).should be_true
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

	describe 'IGNOREGROUP tests' do

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
				post 'ignoregroup'
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

			it 'should return the correct error' do
				errormessage = "Missing Params"
				(response.body.include? errormessage).should be_true
			end


		end

		describe 'ignores group' do

			before(:each) do
				post 'ignoregroup', :ignore => {:id => 4}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

		end

	end


end