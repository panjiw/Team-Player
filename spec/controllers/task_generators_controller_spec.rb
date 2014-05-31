require 'spec_helper'

describe TaskGeneratorsController do

	before(:each) do
	 	@controller = UsersController.new
        post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
          :password => "player", :password_confirmation => "player"}
        post 'create', :user => {:username => "two", :firstname => "New", :lastname => "User", :email => "two@player.com",
          :password => "player", :password_confirmation => "player"}
        post 'create', :user => {:username => "three", :firstname => "New", :lastname => "User", :email => "three@player.com",
           :password => "player", :password_confirmation => "player"}
        post 'create', :user => {:username => "four", :firstname => "New", :lastname => "User", :email => "four@player.com",
           :password => "player", :password_confirmation => "player"}

        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2,3]}
        post 'create', :group => {:name => "own group", :description => "desc"}  		
  	end


# Creates a new task generator base on params
  # Using new generator to create a single task
  #
  # Params required:
  # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
  # task[due_date]: date
  # task[members]: {user_id, ..., user_id} (place in array is order)
  # task[repeat_days]: [boolean, ..., boolean]  1 for each day of the week
  # task[cycle]: boolean
  # Optional:
  # task[description]: description
  #
  # See tasks model in the front end for more info
  #
  # Returns the info of the generator and the new task
  # {"generator":{generator info (see get_all for format)},
  #  "task":{task info (see task_controller for format)}}
  describe 'CREATE test' do

  	context 'creating a simple task' do
  		
  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["false","false","false","false","false","false","false"], :cycle => "false"}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":null,\"cycle\":false"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,"
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  		it 'should save the task information' do
  			@controller = TasksController.new
  			post 'get_all'
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\""
  			(response.body.include? taskinfo).should be_true
  		end

  		it 'should save the finished information' do
  			@controller = TasksController.new
  			post 'get_all'
  			finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true
  		end

  		it 'should save the member information' do
  			@controller = TasksController.new
  			post 'get_all'
  			 memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
  		end

  	end


  	context 'creating a task with a description' do
  		
  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false", :description => "desc"}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":{\"1\":true,\"2\":false,\"3\":false,\"4\":false,\"5\":false,\"6\":false,\"7\":false},\"cycle\":false"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\","
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  		it 'should save the task information' do
  			@controller = TasksController.new
  			post 'get_all'
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\""
  			(response.body.include? taskinfo).should be_true
  		end

  		it 'should save the finished information' do
  			@controller = TasksController.new
  			post 'get_all'
  			finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true
  		end

  		it 'should save the member information' do
  			@controller = TasksController.new
  			post 'get_all'
  			 memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
  		end

  	end

  	context 'creating a task with a duedate' do
  		
  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":{\"1\":true,\"2\":false,\"3\":false,\"4\":false,\"5\":false,\"6\":false,\"7\":false},\"cycle\":false"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-05-05\""
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  		it 'should save the task information' do
  			@controller = TasksController.new
  			post 'get_all'
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2015-05-05\""
  			(response.body.include? taskinfo).should be_true
  		end

  		it 'should save the finished information' do
  			@controller = TasksController.new
  			post 'get_all'
  			finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true
  		end

  		it 'should save the member information' do
  			@controller = TasksController.new
  			post 'get_all'
  			 memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
  		end

  	end

  	context 'creating a cyclic but not repeating days task' do
  		
  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  				:repeat_days => "", :cycle => "true"}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":null,\"cycle\":true"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  		it 'should save the task information' do
  			@controller = TasksController.new
  			post 'get_all'
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
  			(response.body.include? taskinfo).should be_true
  		end

  		it 'should save the finished information' do
  			@controller = TasksController.new
  			post 'get_all'
  			finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true
  		end

  		it 'should save the member information' do
  			@controller = TasksController.new
  			post 'get_all'
  			 memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
  		end

  	end



  	context 'creation failures' do

  		# nil for each thing
  		it 'should return a 400 status when group id is nil' do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => nil, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			(response.status == 400).should be_true
  		end

  		it 'should return a 400 status when title is nil' do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => nil, :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			(response.status == 400).should be_true
  		end

  		it 'should return a 400 status when member is not in group' do
			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1,2], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			(response.status == 400).should be_true
  		end

  		# context 'invalid repeat pattern' do

  		# 	before(:each) do
				# post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  		# 			:repeat_days => ["false","false","false","false","false","false"], :cycle => "false"}
  		# 	end

  		# 	it 'should return a 400 status' do
  		# 		(response.status == 400).should be_true
  		# 	end

  		# 	it 'should return the correct error message' do
  		# 		errormessage = "Invalid repeat pattern"
  		# 		(resposne.body.include? errormessage).should be_true
  		# 	end

  		# end




  	end

  	# context 'generator not needed' do

  	# 	before(:each) do
  	# 		@controller = TaskGeneratorsController.new
  	# 		post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  	# 			:repeat_days => "", :cycle => nil}
  	# 	end

  	# 	it 'should return a 400 status' do
  	# 		(response.status == 400).should be_true
  	# 	end

  	# 	it 'should return the correct error information' do
  	# 		errorinfo = "\"No need for generator\""
  	# 		(response.body.include? errorinfo).should be_true
  	# 	end

  	# end


  end




  # Creates a new task based on the generator of the given task
  # or the task generator instance set
  # If the former the task must be the most recent task created by
  # the generator
  # Returns the info of the generator and the new task
  # {"generator":{generator info (see get_all for format)},
  #  "task":{task info (see task_controller for format)}}


  describe 'GETALL tests' do

  	context 'user has no task generators' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			get 'get_all'
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return an empty array' do
  			(response.body.include? "{}").should be_true
  		end

  	end

  	context 'user has one task generator' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["false","false","false","false","false","false","false"], :cycle => "false"}
  			get 'get_all'
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":null,\"cycle\":false"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,"
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  	end

  	context 'user has two task generators' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["false","false","false","false","false","false","false"], :cycle => "true"}
  			post 'new', :task => {:group_id => 1, :title => "title two", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			get 'get_all'
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"title two\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":{\"1\":true,\"2\":false,\"3\":false,\"4\":false,\"5\":false,\"6\":false,\"7\":false},\"cycle\":false"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"title two\",\"description\":null,"
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

		it 'should return the correct taskgenerator information' do
  			generatorinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"finished_date\":null,\"finished\":false"
  			(response.body.include? generatorinfo).should be_true
  		end

  		it 'should return the correct day and cycle info' do
			dayinfo = "\"repeat_days\":null,\"cycle\":true"
  			(response.body.include? dayinfo).should be_true
  		end

  		it 'should return the correct task information' do
  			taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,"
  			(response.body.include? taskinfo).should be_true
  		end

        it 'should return the correct finished information' do
           	finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
        end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0}"
            (response.body.include? memberinfo).should be_true
        end

  	end

  end
  # Mark the given task generator as finished and unusable anymore
  # Params require:
  # task[id]: id

  describe 'MARKFINISHED tests' do

  	context 'mark a nonrepeating noncycling task as finished' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["false","false","false","false","false","false","false"], :cycle => "false"}
  			post 'mark_finished', :task => {:id => 1}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  	end

  	context 'mark a repeating task as finished' do

		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			post 'mark_finished', :task => {:id => 1}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  	end

  	context 'mark a cycling but not repeating task as finished' do

	before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["false","false","false","false","false","false","false"], :cycle => "true"}
  			post 'mark_finished', :task => {:id => 1}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  	end

  	context 'mark a cycling and repeating task as finished' do

		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			post 'mark_finished', :task => {:id => 1}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  	end

  end


  # Updates the given task generator with the given attributes
  # Deletes the latest task created using the generator and
  # Creates a new one based on the new attributes.
  # Returns the task generator as new.
  # Params require, same as 'new' in addition task[id]
  describe 'EDIT tests' do

  	context 'user successfully edits a task generator' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  		end

  		context 'user successfully edits nothing' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  					:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  		context 'user successfully edits title' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "new title", :total_due => 20, :due_date => nil, :members => [1], 
  					:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  		context 'user successfully edits total due' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 40, :due_date => nil, :members => [1], 
  					:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  		context 'user successfully edits due date' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => "2015-05-05", :members => [1], 
  					:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  		context 'user successfully edits repeated days' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  					:repeat_days => ["true","false","true","false","false","false","false"], :cycle => "true"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  		context 'user successfully edits cycle' do

  			before(:each) do
  				post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  					:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  			end

  			it 'should return a 200 status' do
  				(response.status == 200).should be_true
  			end

  		end

  	end

  	context 'incorrect user trying to edit task generator' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			@controller = SessionsController.new
  			delete 'destroy'
  			post 'create', :user => {:username => "two", :password => "player"}
  			@controller = TaskGeneratorsController.new
  			post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  		end

  		it 'should return a 400 status' do
  			(response.status == 400).should be_true
  		end

  	end

  	context 'user trying to edit user not in group into task' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			post 'edit', :task => {:id => 1, :group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1,2], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
  		end

  		it 'should return a 400 status' do
  			(response.status == 400).should be_true
  		end

  	end

  end


  # Deletes the given task generator and the latest task it created
  describe 'DELETE test' do

  	context 'delete a task generator' do

  		before(:each) do
  			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			post 'delete', :task => {:id => 1}
  		end

  		it 'should return a 200 status' do
  			(response.status == 200).should be_true
  		end

  		it 'should return an empty array' do
  			get 'get_all'
  			(response.body.include? "{}").should be_true
  		end

  	end

  	context 'wrong user is trying to delete a task' do

  		before(:each) do
			@controller = TaskGeneratorsController.new
  			post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
  				:repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
  			@controller = SessionsController.new
  			delete 'destroy'
  			post 'create', :user => {:username => "two", :password => "player"}
  			@controller = TaskGeneratorsController.new
  			post 'delete', :task => {:id => 1}
  		end

  		it 'should return a 400 status' do
  			(response.status == 400).should be_true
  		end

  	end

  end


  describe 'GET_IN_RANGE tests' do

    context 'the user does not have any task geerators' do

      before(:each) do
        @controller = TaskGeneratorsController.new
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an empty array' do
        (response.body.include? "{}").should be_true
      end

    end

    context 'the user has one task generator above range' do

      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2030-05-05", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an empty array' do
        (response.body.include? "{}").should be_true
      end

    end

    context 'the user has one task generator above range by one' do

      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-16", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an empty array' do
        (response.body.include? "{}").should be_true
      end

    end

    context 'the user has one task generator below range' do
      
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2010-07-16", :members => [1], 
          :repeat_days => ["false","false","false","false","false","false","false"], :cycle => "true"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an empty array' do
        (response.body.include? "{}").should be_true
      end

    end

    context 'the user has one task generator below range by one' do
     
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-01", :members => [1], 
          :repeat_days => ["false","false","false","false","false","false","false"], :cycle => "true"}
        get 'get_in_range', :date => {:start => "2020-07-02", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an empty array' do
        (response.body.include? "{}").should be_true
      end
    
    end

    context 'the user has one task generator in range' do
      
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-10", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end
    
    end

    context 'the user has one task generator on bottom edge of the range' do
     
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-01", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end
    
    end

    context 'the user has one task generator on the top edge of the range' do
      
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-15", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end

    end

    context 'the user has one task generator in range one task generator out of range' do
      
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-10", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        post 'new', :task => {:group_id => 1, :title => "title two", :total_due => 20, :due_date => "2021-07-10", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end

      it 'should not return an the second task info' do
        taskinfo = "\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"title two\""
        (response.body.include? taskinfo).should be_false
      end

    end

    context 'the user has two task generators in range' do
      
      before(:each) do
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-10", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => "2020-07-11", :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "false"}
        get 'get_in_range', :date => {:start => "2020-07-01", :end => "2020-07-15"}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end

      it 'should return an the correct task info' do
        taskinfo = "\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"title\""
        (response.body.include? taskinfo).should be_true
      end

    end



  end


end
