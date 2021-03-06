#
# TeamPlayer -- 2014
#
# This file tests the TasksController functionality 
#

require 'spec_helper'

describe TasksController do

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
        post 'create', :user => {:username => "five", :firstname => "New", :lastname => "User", :email => "five@player.com",
           :password => "player", :password_confirmation => "player"}
            
        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "group name", :description => "desc"}, :add => {:members => [1,2,3,4]}

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

        @controller = GroupsController.new
        post 'create', :group => {:name => "own group", :description => "desc"}
    end

# new
describe "NEW tests" do

    describe 'user is not signed in' do

      before(:each) do
        @controller = SessionsController.new
        delete 'destroy'
        @controller = TasksController.new
        post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
      end

      it 'should return a 302 status and redirect the user' do
        (response.status == 302).should be_true
      end

    end

    # correct with only required fields
    describe 'only required fields inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
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

      end

    # correct with required fields and description
    describe 'only required fields and description inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :description => "desc"}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

        it 'should return the correct task information' do
          taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":null"
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

    # correct with required fields and dateDue
     describe 'only required fields and dueDate inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2015-05-05"}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
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

      end

    # correct with required fields description and dateDue
    describe 'required fields, description, and dueDate inputed' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2015-05-05", :description => "desc"}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

        it 'should return the correct task information' do
            taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2015-05-05\""
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

    # correct with self group
    describe 'creates a task for a self group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
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

      end

    # correct with one person on one task
    describe 'creates a task with one person on one task' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [4]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

         it 'should return the correct task information' do
            taskinfo = "{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
            (response.body.include? taskinfo).should be_true
          end

        it 'should return the correct finished information' do
            finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
          end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"4\":0}"
            (response.body.include? memberinfo).should be_true
          end

      end

    # correct with two people on one task
    describe 'creates a task with two people on one task' do

        before(:each) do

          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}

          @controller = TasksController.new
          post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1,2]}


          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

        it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
              (response.body.include? taskinfo).should be_true
          end

        it 'should return the correct finished information' do
            finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
          end

        it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0,\"2\":1}"
            (response.body.include? memberinfo).should be_true
          end


      end

    # correct with three people on one task
    describe 'creates a task with three people including the creator on one task' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1,2,3]}
          end

        it 'should return a 200 status' do
          (response.status == 200).should be_true
          end

        it 'should return the correct task information' do
          taskinfo = "{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
          (response.body.include? taskinfo).should be_true
          end

        it 'should return the correct finished information' do
          finishedinfo = "\"finished\":false"
          (response.body.include? finishedinfo).should be_true            
          end

        it 'should return the correct member information' do
          memberinfo = "\"members\":{\"1\":0,\"2\":1,\"3\":2}"
          (response.body.include? memberinfo).should be_true
          end



      end

    # members not in group failure
    describe 'does not create a task because member is not in the group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [1]}
          end

        it 'should return a 400 status' do
          (response.status == 400).should be_true
          end

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

      end

    # creator not in group
    describe 'does not create the task because member is not in group' do

        before(:each) do
          @controller = SessionsController.new
          post 'create', :user => {:username => "one", :password => "player"}
          @controller = TasksController.new
          post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [4]}
          end

        it 'should return a 400 status' do
          (response.status == 400).should be_true
          end

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
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return a blank array' do
      (response.body.include? "{}").should be_true
    end

  end

  context 'the user is not signed in' do

    it 'should return a 302 status' do
      @controller = SessionsController.new
      delete 'destroy'
      @controller = TasksController.new
      get 'get_all'
      (response.status == 302).should be_true
    end

  end

  context 'user has one task they created' do
    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should have the correct task information for task one' do
      taskinfo = "0\":{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
      (response.body.include? taskinfo).should be_true
    end

  end

  context 'user has one tasks they did not create' do
    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [4]}
      @controller = SessionsController.new
      post 'create', :user => {:username => "four", :password => "player"}
      @controller = TasksController.new
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return the correct task information for task one' do
      taskinfo = "0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
      (response.body.include? taskinfo).should be_true
    end
  end

  context 'the user has more than one task they created' do

    before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "6", :title => "first", :finished => false, :members => [3,4]}
      post 'new', :task => {:group_id => "6", :title => "second", :finished => false, :members => [4]}
      get 'get_all'
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return the correct task information for the first task' do
      taskinfo = "0\":{\"details\":{\"id\":1,\"group_id\":6,\"user_id\":1,\"title\":\"first\",\"description\":null,\"due_date\":null"
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "1\":{\"details\":{\"id\":2,\"group_id\":6,\"user_id\":1,\"title\":\"second\",\"description\":null,\"due_date\":null"
      (response.body.include? taskinfo).should be_true
    end

      # "members":{user_id:order, ..., user_id:order}}}, ...}

    it 'should return the correct member information for the first task' do
      memberinfo = "\"members\":{\"3\":0,\"4\":1}"
      (response.body.include? memberinfo).should be_true
    end

    it 'should return the correct member information for the second task' do
      memberinfo = "\"members\":{\"4\":0}"
      (response.body.include? memberinfo).should be_true
    end

  end

  context 'the user is not logged in' do

    before(:each) do
        @controller = SessionsController.new
        delete 'destroy'
        @controller = TasksController.new
        post 'new', :task => {:group_id => "6", :title => "second", :finished => false, :members => [4]}
    end

    it 'should redirect the user' do
      (response.status == 302).should be_true
    end

  end

end

# mark_finished
  # Mark the task with the given id as finished
  # Returns the info of the task
describe 'MARK_FINISHED tests' do

   before(:each) do
      @controller = SessionsController.new
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [2]}
      @controller = SessionsController.new
      delete 'destroy'

      @controller = SessionsController.new
      post 'create', :user => {:username => "two", :password => "player"}
      @controller = TasksController.new
      post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [3,4]}
      post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [2]}
      # puts "here"
      # puts response.body
    end

  # user not signed in
  context 'the user is not signed in' do

    before(:each) do
      @controller = SessionsController.new
      delete 'destroy'
      @controller = TasksController.new
      post 'mark_finished', :task => {:id => "1"}
    end

    it 'it should redirect the user' do
      (response.status == 302).should be_true
    end

  end

  # not a member of the task
  context 'the user is not a member of the task' do

    before(:each) do
      @controller = TasksController.new
      post 'mark_finished', :task => {:id => "2"}
    end

    it 'it should return a 400 status' do
      (response.status == 400).should be_true
    end

  end

  # task finished successfully; check info
  context 'the task is marked as finished' do

    before(:each) do
      @controller = TasksController.new
      post 'mark_finished', :task => {:id => "3"}
    end

    it 'it should return a 200 status' do
      (response.status == 200).should be_true
    end

  end

  context 'the task is already finished' do

    before(:each) do
      @controller = TasksController.new
      post 'mark_finished', :task => {:id => "3"}
      @controller = SessionsController.new
      delete 'destroy'
      post 'create', :user => {:username => "one", :password => "player"}
      @controller = TasksController.new
      post 'mark_finished', :task => {:id => "3"}
    end

    it 'it should return a 400 status' do
      (response.status == 400).should be_true
    end

  end

  # marking tasks from taskgenerators finished

  context 'taskgenerator task is finished' do

    context 'cycling task is finished' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
          :repeat_days => ["false","false","false","false","false","false","false"], :cycle => "true"}
        @controller = TasksController.new
        post 'mark_finished', :task => {:id => "4"}
        end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

    end

    context 'repeating task is finished' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
          :repeat_days => ["false","true","false","false","false","false","false"], :cycle => "false"}
        @controller = TasksController.new
        post 'mark_finished', :task => {:id => "4"}
        end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

    end

    context 'cycling and repeating task is finished' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}
        @controller = TaskGeneratorsController.new
        post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
          :repeat_days => ["true","false","false","false","false","false","false"], :cycle => "true"}
        @controller = TasksController.new
        post 'mark_finished', :task => {:id => "4"}
        end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

    end


  end


end


# # tasks in range
#   # Returns all the tasks of the signed in user within the
#   # given (through get) range: date[start] <= task[:created_at] <= date[end]
#   # {number starting from 0:{"details":{
#   # "id":task id,
#   # "group_id":group id of the task,
#   # "user_id":1,
#   # "title":task title,
#   # "description": task_description,
#   # "due_date":due date,
#   # "finished_date":finished date,
#   # "finished":finished,
#   # "created_at":date and time created,
#   # "updated_at":date and time updated},
#   # "members":{user_id:order, ..., user_id:order}}, ...}
describe "TEST get_in_range" do

  describe 'user has a repeating task in range' do

    before(:each) do
      @controller = TaskGeneratorsController.new
      post 'new', :task => {:group_id => 1, :title => "title", :total_due => 20, :due_date => nil, :members => [1], 
          :repeat_days => ["true","false","true","false","false","true","false"], :cycle => "false", :description => "desc"}
      @controller = TasksController.new
      get 'get_in_range', :date => {:start => "2014-07-01", :end => "2014-07-15"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-07-02\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-07-05\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-07-07\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-07-09\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-07-12\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return the correct task information for the second task' do
      taskinfo = "\"id\":null,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":\"2014-06-14\""
      (response.body.include? taskinfo).should be_true
    end

  end

  describe 'user has no tasks' do

    before(:each) do
      @controller = TasksController.new
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return no tasks' do
      (response.body.include? "{}").should be_true
    end

  end

  describe 'user has one task above the given range' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-07-05"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return no tasks' do
      (response.body.include? "{}").should be_true
    end

  end

  describe 'user has one task below the given range' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-04-04"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return no tasks' do
      (response.body.include? "{}").should be_true
    end

  end

  describe 'user has one task one outside the upper borded' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-06-02"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      (response.body.include? "{}").should be_true
    end

  end

  describe 'user has one task one outside the lower borded' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-04-30"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      (response.body.include? "{}").should be_true
    end

  end

  describe 'user has one task on the lower borded' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-05-05"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-05\""
      (response.body.include? taskinfo).should be_true
    end

  end


  describe 'user has one task on the upper borded' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-06-01"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-06-01\""
      (response.body.include? taskinfo).should be_true
    end

  end

  describe 'user has one task between the two dates' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-05-15"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-15\""
      (response.body.include? taskinfo).should be_true
    end

  end

  describe 'user has one task outside the border one task inside the border' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-05-15"}
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-07-01"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return one task' do
      taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-15\""
      (response.body.include? taskinfo).should be_true
    end

  end

  describe 'user has two tasks inside the border' do

    before(:each) do
      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-05-15"}
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2020-05-20"}
      get 'get_in_range', :date => {:start => "2020-05-01", :end => "2020-06-01"}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    it 'should return correct task info' do
      taskinfo = "\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-15\""
      (response.body.include? taskinfo).should be_true
    end

    it 'should return correct task info' do
      taskinfo = "\"id\":2,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":\"2020-05-20\""
      (response.body.include? taskinfo).should be_true
    end

  end

end


describe "EDIT tests" do

  before(:each) do
    @controller = SessionsController.new
    post 'create', :user => {:username => "one", :password => "player"}
    @controller = TasksController.new
    post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
    post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1]}
    post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1,2]}
    post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :description => "desc"}
    post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2015-05-05"}
  end


  describe 'user is not signed in' do

      before(:each) do
        @controller = SessionsController.new
        delete 'destroy'
        @controller = TasksController.new
        post 'edit', :task => {:id => 1, :group_id => "1", :title => "title", :finished => false, :members => [1]}
      end

      it 'should return a 302 status and redirect the user' do
        (response.status == 302).should be_true
      end

    end

  # edit one aspect for each test
  describe 'only title changed' do
        before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "1",:group_id => "1", :title => "newtitle", :finished => false, :members => [1]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"newtitle\",\"description\":null,\"due_date\":null"
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

  describe 'add a member' do
        before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "2",:group_id => "6", :title => "title", :finished => false, :members => [1,2]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":2,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
              (response.body.include? taskinfo).should be_true
          end

          it 'should return the correct finished information' do
            finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
          end

          it 'should return the correct member information' do
            memberinfo = "\"members\":{\"1\":0,\"2\":1}"
            (response.body.include? memberinfo).should be_true
          end

      end

      describe 'delete a member' do
        before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [1]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
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

      describe 'delete the first member' do
        before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [2]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
              (response.body.include? taskinfo).should be_true
          end

          it 'should return the correct finished information' do
            finishedinfo = "\"finished\":false"
            (response.body.include? finishedinfo).should be_true            
          end

          it 'should return the correct member information' do
            memberinfo = "\"members\":{\"2\":0}"
            (response.body.include? memberinfo).should be_true
          end

      end

      describe 'add a description' do
          before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "1",:group_id => "1", :title => "title", :finished => false, :members => [1], :description => "desc"}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":1,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":\"desc\",\"due_date\":null"
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

      # ?????
      describe 'delete a description' do
          
          before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "4",:group_id => "1", :title => "title", :finished => false, :members => [1]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":4,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
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

      describe 'add a duedate' do    
          before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "1",:group_id => "1", :title => "title", :finished => false, :members => [1], :due_date => "2015-05-05"}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
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
      end

      describe 'delete a duedate' do    
          before(:each) do
          @controller = TasksController.new
          post 'edit', :task => {:id => "5",:group_id => "1", :title => "title", :finished => false, :members => [1]}
          end

          it 'should return a 200 status' do
            (response.status == 200).should be_true
          end

          it 'should return the correct task information' do
              taskinfo = "{\"details\":{\"id\":5,\"group_id\":1,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
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

  # CURRENT FUNCTIONALITY: EDIT CHANGEGS THE CREATOR ID TO THE ID OF THE CREATOR
  describe 'user not creator of the task' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "two", :password => "player"}
        @controller = TasksController.new
        post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [1]}
      end

      it 'should return a 200 status' do
        (response.status == 200).should be_true
      end

      it 'should return the correct task information' do
          taskinfo = "{\"details\":{\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
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

  # user does not have the permission to edit the task
  describe 'user is not part of the task' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "three", :password => "player"}
        @controller = TasksController.new
        post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [1]}
      end

      it 'should return a 400 status' do
        (response.status == 400).should be_true
      end

      # not change the info
      context 'altering information' do
       
        before(:each) do
           @controller = SessionsController.new
           delete 'destroy'
           post 'create', :user => {:username => "two", :password => "player"}
           @controller = TasksController.new
           get 'get_all'
        end

        it 'should not change the task information' do
          taskinfo = "\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
          (response.body.include? taskinfo).should be_true
        end

        it 'should return the correct finished information' do
         finishedinfo = "\"finished\":false"
         (response.body.include? finishedinfo).should be_true            
        end

        it 'should not change the member information' do
           memberinfo = "\"members\":{\"1\":0,\"2\":1}"
          (response.body.include? memberinfo).should be_true
        end

      end

  end

  describe 'user attempted to add does not exist' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "one", :password => "player"}
        @controller = TasksController.new
        post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [9]}
      end

     it 'should return a 400 status' do
        (response.status == 400).should be_true
      end


  end

  # describe 'task not a part of the group' do

  #   before(:each) do
  #       @controller = SessionsController.new
  #       post 'create', :user => {:username => "one", :password => "player"}
  #       @controller = TasksController.new
  #       post 'edit', :task => {:id => "2",:group_id => "1", :title => "title", :finished => false, :members => [1]}
  #     end

  #    it 'should return a 400 status' do
  #       (response.status == 400).should be_true
  #     end

  # end

  describe 'user is not part of group' do

      before(:each) do
        @controller = SessionsController.new
        post 'create', :user => {:username => "five", :password => "player"}
        @controller = TasksController.new
        post 'edit', :task => {:id => "3",:group_id => "6", :title => "title", :finished => false, :members => [1]}
      end

     it 'should return a 400 status' do
        (response.status == 400).should be_true
      end

      context 'altering information' do
       
        before(:each) do
           @controller = SessionsController.new
           delete 'destroy'
           post 'create', :user => {:username => "two", :password => "player"}
           @controller = TasksController.new
           get 'get_all'
        end

        it 'should not change the task information' do
          taskinfo = "\"id\":3,\"group_id\":6,\"user_id\":1,\"title\":\"title\",\"description\":null,\"due_date\":null"
          (response.body.include? taskinfo).should be_true
        end

       it 'should return the correct finished information' do
         finishedinfo = "\"finished\":false"
         (response.body.include? finishedinfo).should be_true            
        end
        
        it 'should not change the member information' do
           memberinfo = "\"members\":{\"1\":0,\"2\":1}"
          (response.body.include? memberinfo).should be_true
        end

      end

  end


end


# delete
describe 'DELETE tests' do

  before(:each) do
    @controller = TasksController.new
    post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
  end

  # user not logged in
  describe 'user is not logged in' do

    before(:each) do
      @controller = SessionsController.new
      delete 'destroy'
      @controller = TasksController.new
      delete 'delete', :task => {:id => 1}
    end

    it 'should redirect the user' do
      (response.status == 302).should be_true
    end

  end

  # user not authorized
  describe 'user is not logged in' do

    before(:each) do
      @controller = SessionsController.new
      delete 'destroy'
      post 'create', :user => {:username => "five", :password => "player"}
      @controller = TasksController.new
      delete 'delete', :task => {:id => 1}
    end

    it 'should return a 400 status' do
      (response.status == 400).should be_true
    end

  end

  # delete is possible
  describe 'the delete is authorized' do

    before(:each) do
      @controller = TasksController.new
      delete 'delete', :task => {:id => 1}
    end

    it 'should return a 200 status' do
      (response.status == 200).should be_true
    end

    # check if it was deleted
    # check returns

  end

end




end