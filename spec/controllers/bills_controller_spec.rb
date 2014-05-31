#
# TeamPlayer -- 2014
#
# This file tests the BillsController functionality 
#

require 'spec_helper'

describe BillsController do

	describe "NEW tests" do

		# populate a database to interact with
		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        	:password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        	:password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "three", :firstname => "New", :lastname => "User", :email => "three@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "four", :firstname => "New", :lastname => "User", :email => "four@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "five", :firstname => "New", :lastname => "User", :email => "five@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	            
	     	@controller = SessionsController.new
	        post 'create', :user => {:username => "takenname", :password => "player"}

	        @controller = GroupsController.new
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [2,3,4]}

			@controller = SessionsController.new
			delete 'destroy'
	        post 'create', :user => {:username => "two", :password => "player"}
	        
	        @controller = GroupsController.new
	        post 'acceptgroup', :accept => {:id => "6"}


			@controller = SessionsController.new
			delete 'destroy'
	        post 'create', :user => {:username => "three", :password => "player"}
	        
	        @controller = GroupsController.new
	        post 'acceptgroup', :accept => {:id => "6"}


			@controller = SessionsController.new
			delete 'destroy'
	        post 'create', :user => {:username => "four", :password => "player"}
	        
	        @controller = GroupsController.new
	        post 'acceptgroup', :accept => {:id => "6"}

			
			@controller = SessionsController.new
			delete 'destroy'
	        post 'create', :user => {:username => "takenname", :password => "player"}

	        @controller = GroupsController.new

			end

		context 'the bill has a negative value' do

			before(:each) do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 30, :members => {"1" => -1, "2" => 31}, 
						 :description => "desc", :due_date => "2014-05-17"}
			end

			it 'should have a 400 status' do
				(response.status == 400).should be_true
			end

		end

		context 'the user is not logged in' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
			end

			it 'should redirect the user' do
				(response.status == 302).should be_true
			end

		end

		# test creating a bill functions correctly
		context 'the user creates a bill with one user' do
			
			# creating a bill for self
			context 'should create a bill with correct information' do

				before(:each) do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					end
				
				it 'should have the correct status' do
					(response.status == 200).should be_true
					end

				it 'should have the correct user information' do
					checker = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
					end

				it 'should have the correct bill information' do
					checker = "\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\",\"total_due\":30"
					(response.body.include? checker).should be_true
					end

				end

			# bill not created because of information problems
			context 'should not create bill' do
			
				it 'user owing is not part of the group' do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"5" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					(response.status == 400).should be_true
					end

				it 'user is not in the group' do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 4, :title => "testing title", :total_due => 30, :members => {"5" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					(response.status == 400).should be_true
					end

				it 'user does not exist' do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"9" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					(response.status == 400).should be_true
					end

				it 'group does not exist' do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 9, :title => "testing title", :total_due => 30, :members => {"4" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					(response.status == 400).should be_true
					end
			end

			#creating a bill for another person
			context 'should create a bill with correct information' do
				before(:each) do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 6, :title => "new title", :total_due => 20, :members => {"2" => 20}, 
						:description => "desc", :due_date => "2014-05-17"}			
					end

				it 'should have the correct status' do
					(response.status == 200).should be_true
					end

				it 'should have the correct user information' do
					checker = "\"2\":{\"due\":20,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
					end

				it 'should have the correct bill information' do
					checker = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"new title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\",\"total_due\":20"
					(response.body.include? checker).should be_true
					end

				end

			# creating a bill with multiple people
			context 'should create a bill for multiple users and return that information' do
				
				before(:each) do
					@controller = BillsController.new
					post 'new', :bill => {:group_id => 6, :title => "new title", :total_due => 40, :members => {"2" => 20,"3" => 20}, 
						:description => "desc", :due_date => "2014-05-17"}			
					end

				it 'should have the correct status' do
					(response.status == 200).should be_true
					end

				it 'should have the correct user information for user 2' do
					checker = "\"2\":{\"due\":20,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
					end

				it 'should have the correct user information for user 3' do
					checker = "\"3\":{\"due\":20,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
					end

				it 'should have the correct bill information' do
					checker = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"new title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
					(response.body.include? checker).should be_true
					end

			 	end

		end

		context 'the user creates a bill where a member does not exist' do

			before(:each) do
				@controller = SessionsController.new
	        	post 'create', :user => {:username => "takenname", :password => "player"}
	        	@controller = BillsController.new
				post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"99" => 20}, 
					 :description => "desc", :due_date => "2014-05-17"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		# tests creating a bill when prices do not add up
		context 'the user creates a bill where prices do not add up' do
			
			before(:each) do
				@controller = SessionsController.new
	        	post 'create', :user => {:username => "takenname", :password => "player"}
	        	@controller = BillsController.new
				end

			# one person
			it 'should throw an exception' do
				post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 20}, 
					 :description => "desc", :due_date => "2014-05-17"}
				(response.status == 400).should be_true
				end

			# two people bills don't add up
			it 'should throw an exception' do
				@controller = SessionsController.new
				delete 'destroy'
	        	post 'create', :user => {:username => "two", :password => "player"}
	        	@controller = BillsController.new
				post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"2" => 20, "3" => 15}, 
					 :description => "desc", :due_date => "2014-05-17"}
				(response.status = 400).should be_true
			end

		end

		# bill creator is not in group, but other members are
		context 'bill creator is not in group but ohter members are' do

			before(:each) do
				@controller = SessionsController.new
	        	delete 'destroy'
	        	post 'create', :user => {:username => "five", :password => "player"}
	        	@controller = BillsController.new
	        	post 'new', :bill => {:group_id => 6, :title => "test", :total_due => 42, :members => {"3" => 42}, 
					 :description => "desc", :due_date => "2014-05-17"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end	

			#check specific error message
			it 'should return the correct error message' do
				errormessage = "[\"User five isn't in the group\"]"
				(response.body.include? errormessage)
			end

		end

	end

	#tests for getbill
	describe "GETALL tests" do	

		# tests what is returned when the user isn't signed in
		context 'user is not signed in' do
			it 'should not show bills' do
				get 'get_all'
				(response.status == 302).should be_true
			end

		end

		# tests what is returned when user is signed in
		context 'user is signed in' do
			
			before(:each) do
				@controller = UsersController.new
				post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        		 :password => "player", :password_confirmation => "player"}
	            
	        	@controller = SessionsController.new
	        	post 'create', :user => {:username => "takenname", :password => "player"}
		
	        	@controller = BillsController.new
			end

			#
			# ZERO BILLS TESTS
			#

			# zero bills in database
			context 'zero bills in database' do
				
				before(:each) do
					get 'get_all'
				end

				it 'should return an empty array' do
	 				(response.body.include? "{}").should be_true
	 			end

	 			it 'should return 200 status' do
	        		(response.status == 200).should be_true
				end

			end

			# bills in database; no bills for current user
			context 'bills in database no bills for current user' do
				
				before(:each) do
					post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}

					@controller = UsersController.new
					post 'create', :user => {:username => "newuser", :firstname => "New", :lastname => "User", :email => "new@player.com",
		        		 :password => "player", :password_confirmation => "player"}
		            
		        	@controller = SessionsController.new
		        	post 'create', :user => {:username => "newuser", :password => "player"}
			
		        	@controller = BillsController.new
					
					get 'get_all'
				end

				it 'should return an empty array' do
	 				(response.body.include? "{}").should be_true
	        	end

	        	it 'should return a 200 status' do
					(response.status == 200).should be_true
				end

			end

			# bills in user's groups but not for user
			context 'bills in users groups but not for the user' do
				
				before(:each) do
					@controller = UsersController.new
					post 'create', :user => {:username => "newuser", :firstname => "New", :lastname => "User", :email => "new@player.com",
		        		 :password => "player", :password_confirmation => "player"}
		            
		        	@controller = SessionsController.new
		        	post 'create', :user => {:username => "newuser", :password => "player"}

		        	@controller = GroupsController.new
					post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1]}

					@controller = BillsController.new
					post 'new', :bill => {:group_id => 3, :title => "testing title", :total_due => 30, :members => {"2" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}

					@controller = SessionsController.new
					delete 'destroy'
		        	post 'create', :user => {:username => "takenname", :password => "player"}

		        	@controller = BillsController.new
		        	get 'get_all'
		        end

		        it 'should return an empty array' do
	        		(response.body.include? "{}").should be_true
	        	end

	        	it 'should return a 200 status' do
	        		(response.status == 200).should be_true
				end

			end

			#
			#SELF GROUP TESTS
			#

			# one self bill correct response
			context 'one self bill created' do
	        	
		        before(:each) do
		        	post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					get 'get_all'
				end

				it 'should have the correct user information' do
					checker = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
				end

				it 'should have the correct bill information' do
					# check return data for bill information
					checker = "\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
					(response.body.include? checker).should be_true
				end
				
				it 'should return a 200 status' do
					(response.status == 200).should be_true
				end

			end

			# two self bills correct response
			context 'two self bills created' do
	        	
				before(:each) do
		        	post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2014-05-17"}
					post 'new', :bill => {:group_id => 1, :title => "SECOND BILL", :total_due => 20, :members => {"1" => 20}, 
						 :description => "desc", :due_date => "2014-05-17"}
					get 'get_all'
				end
				
				it 'should have the correct user informatino for user one' do
					# check return data for user information
					checker = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
				end

				it 'should have the correct bill information for bill one' do
					# check return data for bill information
					checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
					(response.body.include? checker).should be_true
				end

				it 'should have the correct user information for user one bill two' do
					# check return data for user information
					checker = "\"1\":{\"due\":20,\"paid\":false,\"paid_date\":null"
					(response.body.include? checker).should be_true
				end

				it 'should have the correct bill information for bill two' do
					# check return data for bill information
					checker = "\"1\":{\"details\":{\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"SECOND BILL\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
					(response.body.include? checker).should be_true
				end

				it 'should have the correct status' do
					(response.status == 200).should be_true
				end

			end	
			
			#
			# DIFFERENT OWES/OWED FUNCTIONALITY
			#

			context 'testing group functionality' do

				before(:each) do
					@controller = UsersController.new
					post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        			 :password => "player", :password_confirmation => "player"}
	        		post 'create', :user => {:username => "three", :firstname => "New", :lastname => "User", :email => "three@player.com",
	        			 :password => "player", :password_confirmation => "player"}
	        		post 'create', :user => {:username => "four", :firstname => "New", :lastname => "User", :email => "four@player.com",
	        			 :password => "player", :password_confirmation => "player"}
	        		post 'create', :user => {:username => "five", :firstname => "New", :lastname => "User", :email => "five@player.com",
	        			 :password => "player", :password_confirmation => "player"}
	            
	        		@controller = SessionsController.new
	        		post 'create', :user => {:username => "two", :password => "player"}

	        		@controller = GroupsController.new
					post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2,3,4,5]}

					@controller = SessionsController.new
					delete 'destroy'
			        post 'create', :user => {:username => "three", :password => "player"}
			        
			        @controller = GroupsController.new
			        post 'acceptgroup', :accept => {:id => "6"}


			        @controller = SessionsController.new
	    	    	delete 'destroy'
	    	    	post 'create', :user => {:username => "takenname", :password => "player"}
		
	    	    	@controller = GroupsController.new
			        post 'acceptgroup', :accept => {:id => "6"}	

					@controller = SessionsController.new
					delete 'destroy'
			        post 'create', :user => {:username => "four", :password => "player"}
			        
			        @controller = GroupsController.new
			        post 'acceptgroup', :accept => {:id => "6"}

					@controller = SessionsController.new
					delete 'destroy'
			        post 'create', :user => {:username => "five", :password => "player"}
			        
			        @controller = GroupsController.new
			        post 'acceptgroup', :accept => {:id => "6"}


					@controller = SessionsController.new
					delete 'destroy'
			        post 'create', :user => {:username => "two", :password => "player"}

			        @controller = GroupsController.new
				end

				# user owes one bill; nothing owed to user
				context 'user owes one bill; nothing owed to user' do
					
					before(:each) do
						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30}, 
							 :description => "desc", :due_date => "2014-05-17"}

						@controller = SessionsController.new
						delete 'destroy'
						post 'create', :user => {:username => "three", :password => "player"}

						@controller = BillsController.new
						get 'get_all'
					end

					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end
					
					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return a 200 status' do
						(response.status == 200).should be_true
					end

				end

				# user owes two bills; nothing owed to user
				context 'user owes two bills/ nothing owed to user' do
					
					before(:each) do
						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30}, 
							 :description => "desc", :due_date => "2014-05-17"}
						post 'new', :bill => {:group_id => 6, :title => "testing two", :total_due => 42, :members => {"3" => 42}, 
							 :description => "desc", :due_date => "2014-05-17"}

						@controller = SessionsController.new
						delete 'destroy'
						post 'create', :user => {:username => "three", :password => "player"}

						@controller = BillsController.new
						get 'get_all'
					end

					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end
					
					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"3\":{\"due\":42,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end

					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"1\":{\"details\":{\"id\":2,\"group_id\":6,\"user_id\":2,\"title\":\"testing two\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return a 200 status' do
						(response.status == 200).should be_true				
					end

				end

				# user owed one bill; user owes nothing
				context 'user owed one bill user owes nothing' do
					
					before(:each) do
						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30, "2" => 0}, 
							 :description => "desc", :due_date => "2014-05-17"}

						@controller = BillsController.new
						get 'get_all'
					end

					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"2\":{\"due\":0,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end

					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should reeturn a 200 status' do
					(response.status == 200).should be_true
					end

				end

				# user owed two bills; user owes nothing
				context 'user owed two bills; user owes nothing' do
					
					before(:each) do
						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30,"2" => 0}, 
							 :description => "desc", :due_date => "2014-05-17"}

						@controller = BillsController.new
						get 'get_all'
					end

					it 'should return correct user information' do
						# check return data for user information
						checker = "\"2\":{\"due\":0,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end

					it 'should return correct bill information' do
						# check return data for bill information
						checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return a 200 status' do
					(response.status == 200).should be_true
					end

				end

				# user owes one bill; one bill owed to user
				context 'user owes one bill; one bill owed to user' do
					
					before(:each) do
						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30}, 
							 :description => "desc", :due_date => "2014-05-17"}

						@controller = SessionsController.new
						delete 'destroy'
						post 'create', :user => {:username => "three", :password => "player"}

						@controller = BillsController.new
						post 'new', :bill => {:group_id => 6, :title => "testing two", :total_due => 30, :members => {"1" => 30,"3" => 0}, 
							 :description => "desc", :due_date => "2014-05-17"}
						get 'get_all'
					end

					
					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end

					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return the correct user information' do
						# check return data for user information
						checker = "\"3\":{\"due\":0,\"paid\":false,\"paid_date\":null"
						(response.body.include? checker).should be_true
					end

					it 'should return the correct bill information' do
						# check return data for bill information
						checker = "\"details\":{\"id\":2,\"group_id\":6,\"user_id\":3,\"title\":\"testing two\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
						(response.body.include? checker).should be_true
					end

					it 'should return a 200 status' do
					(response.status == 200).should be_true
					end

				end	

			end

		end

	end

	describe "EDIT tests" do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        	:password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        	:password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "three", :firstname => "New", :lastname => "User", :email => "three@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "four", :firstname => "New", :lastname => "User", :email => "four@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	        post 'create', :user => {:username => "five", :firstname => "New", :lastname => "User", :email => "five@player.com",
	        	 :password => "player", :password_confirmation => "player"}
	            
	     	@controller = SessionsController.new
	        post 'create', :user => {:username => "one", :password => "player"}

	        @controller = GroupsController.new
			post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [2,3,4]}
			
			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "two", :password => "player"}
			        
			@controller = GroupsController.new
			post 'acceptgroup', :accept => {:id => "6"}

			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "three", :password => "player"}
			        
			@controller = GroupsController.new
			post 'acceptgroup', :accept => {:id => "6"}

			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "four", :password => "player"}
			        
			@controller = GroupsController.new
			post 'acceptgroup', :accept => {:id => "6"}

			@controller = SessionsController.new
			delete 'destroy'
	        post 'create', :user => {:username => "one", :password => "player"}

			@controller = BillsController.new
			post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}}
			
			post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc"}

			post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :due_date => "2015-05-05"}

			post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2015-05-05"}
		
			post 'new', :bill => {:group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"2" => 20}, 
						 :description => "desc", :due_date => "2015-05-05"}
		end

		# edit bill but - change nothing
		describe 'edit bill but change nothing' do

			before(:each) do
				post 'edit', :bill => {:id => 4, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc", :due_date => "2015-05-05"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":4,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2015-05-05\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# edit title
		describe 'edit only bill title' do

			before(:each) do
				post 'edit', :bill => {:id => 1, :group_id => 6, :title => "new title", :total_due => 30, :members => {"1" => 30}}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"new title\",\"description\":null,\"due_date\":null,\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# edit description
		describe 'edit bill description' do

			before(:each) do
				post 'edit', :bill => {:id => 2, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "new desc"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":2,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":\"new desc\",\"due_date\":null,\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# add description
		describe 'add bill description' do

			before(:each) do
				post 'edit', :bill => {:id => 1, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :description => "desc"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":null,\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# delete description
		describe 'edit bill group but change nothing' do

			before(:each) do
				post 'edit', :bill => {:id => 2, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":2,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null,\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# edit total and bill sums
		describe 'edit total and sum information' do

			before(:each) do
				post 'edit', :bill => {:id => 1, :group_id => 6, :title => "title", :total_due => 10, :members => {"1" => 10}}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":10,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null,\"total_due\":10"
				(response.body.include? billinfo).should be_true
			end

		end

		# edit due date
		describe 'edit bill due date' do

			before(:each) do
				post 'edit', :bill => {:id => 3, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, 
						 :due_date => "2020-05-05"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-05\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# delete due date
		describe 'edit bill group but change nothing' do

			before(:each) do
				post 'edit', :bill => {:id => 3, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null,\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# add due data
		describe 'add bill due date' do

			before(:each) do
				post 'edit', :bill => {:id => 1, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 30}, :due_date => "2015-05-05"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-05-05\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		# edit different user's individual dues
		describe 'edit bill individual user dues' do

			before(:each) do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 5,"2" => 45}, 
						 :description => "desc", :due_date => "2015-05-05"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":5,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct user informatin' do
				userinfo = "\"2\":{\"due\":45,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":5,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2015-05-05\",\"total_due\":50"
				(response.body.include? billinfo).should be_true
			end

		end

		# change total sum but only one user
		describe 'edit bill individual user dues' do

			before(:each) do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 60, :members => {"1" => 30,"2" => 30}, 
						 :description => "desc", :due_date => "2015-05-05"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should have the correct user information' do
				userinfo = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct user informatin' do
				userinfo = "\"2\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? userinfo).should be_true
			end

			it 'should have the correct bill information' do
				billinfo = "\"details\":{\"id\":5,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2015-05-05\",\"total_due\":60"
				(response.body.include? billinfo).should be_true
			end

		end

		# bill should not be editted cases
		describe 'invalid bill editted' do

			it 'should not edit bill because new user not in group' do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"5" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

			it 'should not edit bill because new user does not exist' do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"9" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end		

			it 'should not edit bill because group does not exist' do
				post 'edit', :bill => {:id => 5, :group_id => 99, :title => "title", :total_due => 50, :members => {"1" => 30,"5" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

			it 'should not edit bill because multiple prices dont add up' do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 10,"5" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

			it 'should not edit bill because one prices does not add up' do
				post 'edit', :bill => {:id => 1, :group_id => 6, :title => "title", :total_due => 30, :members => {"1" => 5}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

			it 'should not edit bill because prices are above total' do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 20, :members => {"1" => 30,"5" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

			it 'should not create bill because user does not exist' do
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"99" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
				(response.status == 400).should be_true
			end

		end

		context 'the user does not have permission to edit the bill' do

			before(:each) do 
				@controller = SessionsController.new
				delete 'destroy'
				post 'create', :user => {:username => "five", :password => "player"}
				@controller = BillsController.new
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"2" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		context "the user is not signed in" do

			before(:each) do 
				@controller = SessionsController.new
				delete 'destroy'
				@controller = BillsController.new
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"2" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
			end

			it 'should redirect the user' do
				(response.status == 302).should be_true
			end

		end

		context 'added user does not exist' do

			before(:each) do 
				@controller = BillsController.new
				post 'edit', :bill => {:id => 5, :group_id => 6, :title => "title", :total_due => 50, :members => {"1" => 30,"9" => 20}, 
					:description => "desc", :due_date => "2015-05-05"}
			end

			it 'should return status 400' do
				(response.status == 400).should be_true
			end

		end

	end

	describe "DELETE tests" do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        	:password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        	:password => "player", :password_confirmation => "player"}

	        @controller = SessionsController.new
	        post 'create', :user => {:username => "one", :password => "player"}

			@controller = BillsController.new
			post 'new', :bill => {:group_id => 1, :title => "title", :total_due => 30, :members => {"1" => 30}}
			
			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "two", :password => "player"}

			@controller = BillsController.new
			post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, 
						 :description => "desc"}

		end

		# user not signed in
		describe 'user is not signed in' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = BillsController.new
				post 'delete', :bill => {:id => "1"}
			end

			it 'should redirect the user' do
				(response.status == 302).should be_true
			end

		end

		# bill does not exist

		# user not a part of the bill
		describe 'user not a part of the bill' do

			before(:each) do
				@controller = BillsController.new
				post 'delete', :bill => {:id => "1"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end


		# correct update
		describe 'deletes the bill' do

			before(:each) do
				@controller = BillsController.new
				post 'delete', :bill => {:id => "2"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

		end

	end

	describe "MARK FINISHED tests" do 

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        	:password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        	:password => "player", :password_confirmation => "player"}

	        @controller = SessionsController.new
	        post 'create', :user => {:username => "one", :password => "player"}

			@controller = BillsController.new
			post 'new', :bill => {:group_id => 1, :title => "title", :total_due => 30, :members => {"1" => 30}}
			
			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "two", :password => "player"}

			@controller = BillsController.new
			post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, 
						 :description => "desc"}

		end

		# user not signed in
		describe 'user is not signed in' do

			before(:each) do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = BillsController.new
				post 'mark_finished', :bill => {:id => "1"}
			end

			it 'should redirect the user' do
				(response.status == 302).should be_true
			end

		end

		describe 'the user finishes a single task' do

			before(:each) do
				post 'mark_finished', :bill => {:id => "2"}, :bill_actor => {:id => "2"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

		end

		describe 'the user is not assigned to the task' do

			before(:each) do
				post 'mark_finished', :bill => {:id => "1"}, :bill_actor => {:id => "2"}
			end

			it 'should return a 400 status' do
				(response.status == 400).should be_true
			end

		end

		# someone else marks finished i guess

	end


	describe 'GET_IN_RANGE test' do

		before(:each) do
			@controller = UsersController.new
			post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
	        	:password => "player", :password_confirmation => "player"}
			post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
	        	:password => "player", :password_confirmation => "player"}

	        @controller = SessionsController.new
	        post 'create', :user => {:username => "one", :password => "player"}

			
			@controller = SessionsController.new
			delete 'destroy'
			post 'create', :user => {:username => "two", :password => "player"}

			@controller = BillsController.new
		end

		context 'user has no bills' do

			before(:each) do
     			get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return an empty array' do
				(response.body.include? "{}").should be_true
			end

		end

		context 'user has one bill above the range' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2021-07-15"}
     			get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return an empty array' do
				(response.body.include? "{}").should be_true
			end

		end

		context 'user has one bill above the range by one' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2020-07-16"}
     			get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return an empty array' do
				(response.body.include? "{}").should be_true
			end

		end

		context 'user has one bill below the range' do
			
			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2010-07-15"}
     			get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return an empty array' do
				(response.body.include? "{}").should be_true
			end
		
		end

		context 'user has one bill below the range by one' do
			
			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2020-07-01"}
     			get 'get_in_range', :date => {:start => "2020-07-02", :end => "2020-07-15"}
			end
			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return an empty array' do
				(response.body.include? "{}").should be_true
			end
		
		end

		context 'user has one bill in the middle of the range' do
			
			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2015-07-01"}
     			get 'get_in_range', :date => {:start => "2010-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return bill details' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		context 'user has one bill on the lower point of the range' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2010-07-01"}
     			get 'get_in_range', :date => {:start => "2010-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return bill details' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2010-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		context 'user has one bill on the upper point of the range' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2020-07-15"}
     			get 'get_in_range', :date => {:start => "2010-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return bill details' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-07-15\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

		context 'user has one bill in the range one bill outside the range' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2015-07-01"}
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2025-07-01"}
     			get 'get_in_range', :date => {:start => "2010-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return bill details' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

			it 'should not return other bill details' do
				billinfo = "\"id\":2,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2025-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_false
			end

		end

		context 'user has two bills in range' do

			before(:each) do
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2015-07-01"}
				post 'new', :bill => {:group_id => 2, :title => "title", :total_due => 30, :members => {"2" => 30}, :due_date => "2016-07-01"}
     			get 'get_in_range', :date => {:start => "2010-07-01", :end => "2020-07-15"}
			end

			it 'should return a 200 status' do
				(response.status == 200).should be_true
			end

			it 'should return bill details' do
				billinfo = "\"details\":{\"id\":1,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

			it 'should return other bill details' do
				billinfo = "\"id\":2,\"group_id\":2,\"user_id\":2,\"title\":\"title\",\"description\":null,\"due_date\":\"2016-07-01\",\"total_due\":30"
				(response.body.include? billinfo).should be_true
			end

		end

	end

end