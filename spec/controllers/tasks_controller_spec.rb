#
# TeamPlayer -- 2014
#
# This file tests the TasksController functionality 
#

require 'spec_helper'

describe TasksController do

  before(:each) do
        # user only in self group
        @user = User.create! :username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in group and group with self
        @user = User.create! :username => "two", :firstname => "Team", :lastname => "Player", :email => "two@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in three groups
        @user = User.create! :username => "three", :firstname => "Team", :lastname => "Player", :email => "three@player.com",
                              :password => "player", :password_confirmation => "player"
        @user = User.create! :username => "four", :firstname => "Team", :lastname => "Player", :email => "four@player.com",
                              :password => "player", :password_confirmation => "player"
        @user = User.create! :username => "five", :firstname => "Team", :lastname => "Player", :email => "five@player.com",
                              :password => "player", :password_confirmation => "player"

        @controller = SessionsController.new
        post 'create', :user => {:username => "two", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "one group", :description => "one desc"}

        @controller = SessionsController.new
        delete 'destroy'
        post 'create', :user => {:username => "three", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "two group", :description => "two desc"}, :add => {:members => [4]}
        post 'create', :group => {:name => "three group", :description => "three desc"}, :add => {:members => [4,5]}

        @controller = SessionsController.new
        delete 'destroy'
    end


# new
  # Creates a new task where the creator is the signed in user
  # Accepts post request with format of:
  # Required:
  # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
  # task[finished]: false
  # task[members]: {user_id, ..., user_id} (place in array is order)
  # Optional:
  # task[description]: description
  # task[due_date]: dateDue
  #
  # See tasks model in the front end for more info
  #
  # Returns
  # {"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}}
  describe "NEW tests" do

    
      # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
  # task[finished]: false
  # task[members]: {user_id, ..., user_id} (place in array is order)
  # Optional:
  # task[description]: description
  # task[due_date]: dateDue

    # correct with only required fields
    describe 'only required fields inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "two", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [2]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          # check for correct output

      end

    # correct with required fields and description
    describe 'only required fields and description inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "two", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [2]}, :description => "desc"
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # correct with required fields and dateDue
     describe 'only required fields and dueDate inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "two", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [2]}, :due_date => "2015-05-05"
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # correct with required fields description and dateDue
    describe 'required fields, description, and dueDate inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "two", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [2]}, :due_date => "2015-05-05", :description => "desc"
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # self group tasks ?
    # correct with self group
    describe 'creates a task for a self group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "-1", :title => "title", :finished => false, :members => [1]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # correct with one person on one task
    describe 'creates a task with one person on one task' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [4]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # correct with two people on one task
    describe 'creates a task with two people on one task' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "3", :title => "title", :finished => false, :members => [4,5]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end


    # correct with three people on one task
    describe 'creates a task with three people including the creator on one task' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "3", :title => "title", :finished => false, :members => [3,4,5]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

          # check for correct output

      end

    # members not in group failure
    describe 'does not create a task because member is not in the group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [1]}
          end

        it 'should return a 400 status' do
          (response.status == 400).should be_true
          end

          # check for correct output

      end

    # groupID doesn't exist failure
    describe 'does not create the task because group id does not exist' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "99", :title => "title", :finished => false, :members => [4]}
          end

        it 'should return a 400 status' do
          (response.status == 400).should be_true
          end

          # check for correct output

      end

    # creator not in group
    describe 'does not create the task because member is not in group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "three", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [4]}
          end

        it 'should return a 400 status' do
          (response.status == 400).should be_true
          end

          # check for correct output

      end
  end

# get_all
  # Returns all the tasks of the signed in user
  # {number starting from 0:{"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}}, ...}
describe "GETALL tests" do

  context 'user has no tasks' do

    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "three", :password => "player"}
      @controller = TasksController.new
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

  end

  context 'user has one task they created' do
    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "three", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [3,4]}
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

  end

  context 'user has one tasks they did not create' do
    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "three", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [4]}
      @controller = SessionsController.new
      post 'create', :user => {:username => "four", :password => "player"}
      @controller = TasksController.new
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

  end

end


# mark_finished
  # Mark the task with the given id as finished
  # Returns the info of the task


# tasks in range
  # Returns all the tasks of the signed in user within the
  # given (through get) range: date[start] <= task[:created_at] <= date[end]
  # {number starting from 0:{"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}, ...}


describe "TEST get_task_in_range" do

	context "tasks within month range" do

		  # given (through get) range: date[start] <= task[:created_at] <= date[end]

		# range is not formatted correctly- end is earlier than start
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "6-16-2014", :end => "4-16-2014"}
			(response.status = 400).should be_true
		end

		# range is only one date
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
			(response.status = 400).should be_true
		end

		# range is not formatted correctly
		it 'should send back a range' do
			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
			(response.status = 400).should be_true
		end

	end

end


end