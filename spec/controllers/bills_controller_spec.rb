#
# TeamPlayer -- 2014
#
# This file tests the BillsController functionality 
#

require 'spec_helper'

describe BillsController do

#tests for new
describe "testing NEW" do

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
		
		end

	# tests when user does not in do not exist

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
			# post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 20}, 
			# 	 :description => "desc", :due_date => "2014-05-17"}
			# (response.status = 400).should be_true
		end

	end

end

#tests for getbill
describe "testing getbill" do	
	# tests what is returned when the user isn't signed in
	context 'user is not signed in' do
		it 'should not show bills' do
			get 'get_all'
			(response.body.include? "redirected").should be_true
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
		it 'should show ok json query' do
			get 'get_all'
 			(response.body.include? "{}").should be_true
        	(response.status == 200).should be_true
			end

		# bills in database; no bills for current user
		it 'should show blank ok json query' do
			post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
				 :description => "desc", :due_date => "2014-05-17"}

			@controller = UsersController.new
			post 'create', :user => {:username => "newuser", :firstname => "New", :lastname => "User", :email => "new@player.com",
        		 :password => "player", :password_confirmation => "player"}
            
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "newuser", :password => "player"}
	
        	@controller = BillsController.new
			
			get 'get_all'

 			(response.body.include? "{}").should be_true
        	(response.status == 200).should be_true
			
			end

		# bills in user's groups but not for user
		it 'should show blank ok json query' do
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

        	(response.body.include? "{}").should be_true
        	(response.status == 200).should be_true
			end
		
		#
		#SELF GROUP TESTS
		#

		# one self bill correct response
		it 'should show ok json query' do
        	post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
				 :description => "desc", :due_date => "2014-05-17"}
			get 'get_all'
			
			# check return data for user information
			checker = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
			(response.body.include? checker).should be_true
		
			# check return data for bill information
			checker = "\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
			(response.body.include? checker).should be_true

			(response.status == 200).should be_true
			end

		# two self bills correct response
		it 'should show ok json query' do
        	post 'new', :bill => {:group_id => 1, :title => "testing title", :total_due => 30, :members => {"1" => 30}, 
				 :description => "desc", :due_date => "2014-05-17"}
			post 'new', :bill => {:group_id => 1, :title => "SECOND BILL", :total_due => 20, :members => {"1" => 20}, 
				 :description => "desc", :due_date => "2014-05-17"}
			get 'get_all'
			
			# check return data for user information
			checker = "\"1\":{\"due\":30,\"paid\":false,\"paid_date\":null"
			(response.body.include? checker).should be_true
		
			# check return data for bill information
			checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
			(response.body.include? checker).should be_true

			# check return data for user information
			checker = "\"1\":{\"due\":20,\"paid\":false,\"paid_date\":null"
			(response.body.include? checker).should be_true
		
			# check return data for bill information
			checker = "\"1\":{\"details\":{\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"SECOND BILL\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
			(response.body.include? checker).should be_true

			(response.status == 200).should be_true
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
				end

			# user owes one bill; nothing owed to user
			it 'should return one bill' do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30}, 
					 :description => "desc", :due_date => "2014-05-17"}

				@controller = SessionsController.new
				delete 'destroy'
				post 'create', :user => {:username => "three", :password => "player"}

				@controller = BillsController.new
				get 'get_all'

				# check return data for user information
				checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				(response.status == 200).should be_true
				end

			# user owes two bills; nothing owed to user
			it 'should return two bills' do
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

				# check return data for user information
				checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				# check return data for user information
				checker = "\"3\":{\"due\":42,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"1\":{\"details\":{\"id\":2,\"group_id\":6,\"user_id\":2,\"title\":\"testing two\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				(response.status == 200).should be_true				
				end

			# user owed one bill; user owes nothing
			it 'should return one bill' do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30, "2" => 0}, 
					 :description => "desc", :due_date => "2014-05-17"}

				@controller = BillsController.new
				get 'get_all'

				# check return data for user information
				checker = "\"2\":{\"due\":0,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				(response.status == 200).should be_true
				end

			# user owed two bills; user owes nothing
			it 'should return one bill' do
				@controller = BillsController.new
				post 'new', :bill => {:group_id => 6, :title => "testing title", :total_due => 30, :members => {"3" => 30,"2" => 0}, 
					 :description => "desc", :due_date => "2014-05-17"}

				@controller = BillsController.new
				get 'get_all'

				# check return data for user information
				checker = "\"2\":{\"due\":0,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				(response.status == 200).should be_true
				end

			# user owes one bill; one bill owed to user
			it 'should return two bills' do
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

				# check return data for user information
				checker = "\"3\":{\"due\":30,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":2,\"title\":\"testing title\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				# check return data for user information
				checker = "\"3\":{\"due\":0,\"paid\":false,\"paid_date\":null"
				(response.body.include? checker).should be_true
		
				# check return data for bill information
				checker = "\"details\":{\"id\":2,\"group_id\":6,\"user_id\":3,\"title\":\"testing two\",\"description\":\"desc\",\"due_date\":\"2014-05-17\""
				(response.body.include? checker).should be_true

				(response.status == 200).should be_true
				end

			# zero numbers

			end
		end

	end


end