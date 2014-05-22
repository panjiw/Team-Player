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
        post 'create', :group => {:name => "own group", :description => "desc"}
    end


# # new
# describe "NEW tests" do

#     # correct with only required fields
#     describe 'only required fields inputed' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
#           end

#           it 'should return a 200 status' do
#             (response.status == 200).should be_true
#           end

#           it 'should return the correct task information' do
#             taskinfo = "{\"details'|:{\"id\":1,\"group_id\":1,\"user_id\":1"
#             puts response.body
#           end

#           it 'should return the correct finished information' do
            
#           end

#           it 'should return the correct member information' do
            
#           end

#           # check for correct output

#       end

#   # Returns
#   # {"details":{
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
#   # "members":{user_id:order, ..., user_id:order}}}

#     # correct with required fields and description
#     describe 'only required fields and description inputed' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}, :description => "desc"
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # correct with required fields and dateDue
#      describe 'only required fields and dueDate inputed' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}, :due_date => "2015-05-05"
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # correct with required fields description and dateDue
#     describe 'required fields, description, and dueDate inputed' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}, :due_date => "2015-05-05", :description => "desc"
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # correct with self group
#     describe 'creates a task for a self group' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # correct with one person on one task
#     describe 'creates a task with one person on one task' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [4]}
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # correct with two people on one task
#     describe 'creates a task with two people on one task' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1,2]}
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end


#     # correct with three people on one task
#     describe 'creates a task with three people including the creator on one task' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [1,2,3]}
#           end

#         it 'should return a 200 status' do
#           (response.status == 200).should be_true
#           end

#           # check for correct output

#       end

#     # members not in group failure
#     describe 'does not create a task because member is not in the group' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [1]}
#           end

#         it 'should return a 400 status' do
#           (response.status == 400).should be_true
#           end

#           # check for correct output

#       end

#     # groupID doesn't exist failure
#     describe 'does not create the task because group id does not exist' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "three", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "99", :title => "title", :finished => false, :members => [4]}
#           end

#         it 'should return a 400 status' do
#           (response.status == 400).should be_true
#           end

#           # check for correct output

#       end

#     # creator not in group
#     describe 'does not create the task because member is not in group' do

#         before(:each) do
#           @controller = SessionsController.new
#           post 'create', :user => {:username => "one", :password => "player"}
#           @controller = TasksController.new
#           post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [4]}
#           end

#         it 'should return a 400 status' do
#           (response.status == 400).should be_true
#           end

#           # check for correct output

#       end
#   end

# # get_all
#   # Returns all the tasks of the signed in user
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
#   # "members":{user_id:order, ..., user_id:order}}}, ...}
# describe "GETALL tests" do

#   context 'user has no tasks' do

#     before(:each) do
#       @controller = SessionsController.new
#       post 'create', :user => {:username => "one", :password => "player"}
#       @controller = TasksController.new
#       get 'get_all'
#     end

#     it 'should return a 200 status' do
#       (response.status == 200).should be_true
#     end

#   end

#   context 'user has one task they created' do
#     before(:each) do
#       @controller = SessionsController.new
#       post 'create', :user => {:username => "one", :password => "player"}
#       @controller = TasksController.new
#       post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [3,4]}
#       get 'get_all'
#     end

#     it 'should return a 200 status' do
#       (response.status == 200).should be_true
#     end

#   end

#   context 'user has one tasks they did not create' do
#     before(:each) do
#       @controller = SessionsController.new
#       post 'create', :user => {:username => "one", :password => "player"}
#       @controller = TasksController.new
#       post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [4]}
#       @controller = SessionsController.new
#       post 'create', :user => {:username => "four", :password => "player"}
#       @controller = TasksController.new
#       get 'get_all'
#     end

#     it 'should return a 200 status' do
#       (response.status == 200).should be_true
#     end

#   end

# end


# # mark_finished
#   # Mark the task with the given id as finished
#   # Returns the info of the task
# describe 'MARK_FINISHED tests' do

#    before(:each) do
#       @controller = SessionsController.new
#       post 'create', :user => {:username => "one", :password => "player"}
#       @controller = TasksController.new
#       post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [2]}
#       @controller = SessionsController.new
#       delete 'destroy'

#       @controller = SessionsController.new
#       post 'create', :user => {:username => "two", :password => "player"}
#       @controller = TasksController.new
#       post 'new', :task => {:group_id => "6", :title => "title", :finished => false, :members => [3,4]}
#       post 'new', :task => {:group_id => "2", :title => "title", :finished => false, :members => [2]}
#       # puts "here"
#       # puts response.body
#     end

#   # user not signed in
#   context 'the user is not signed in' do

#     before(:each) do
#       @controller = SessionsController.new
#       delete 'destroy'
#       @controller = TasksController.new
#       post 'mark_finished', :task => {:id => "1"}
#     end

#     it 'it should redirect the user' do
#       (response.status == 302).should be_true
#     end

#   end

#   # # task does not exist
#   # context 'the task does not exist' do

#   #   before(:each) do
#   #     @controller = TasksController.new
#   #     post 'mark_finished', :task => {:id => "3"}
#   #   end

#   #   it 'it should return a 400 status' do
#   #     (response.status == 400).should be_true
#   #   end

#   # end

#   # not a member of the task
#   context 'the user is not a member of the task' do

#     before(:each) do
#       @controller = TasksController.new
#       post 'mark_finished', :task => {:id => "2"}
#     end

#     it 'it should return a 400 status' do
#       (response.status == 400).should be_true
#     end

#   end

#   # task finished successfully; check info
#   context 'the task is marked as finished' do

#     before(:each) do
#       @controller = TasksController.new
#       post 'mark_finished', :task => {:id => "3"}
#     end

#     it 'it should return a 200 status' do
#       (response.status == 200).should be_true
#     end

#   end

#   # adding self task ?


# end


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
# describe "TEST get_task_in_range" do

# 	context "tasks within month range" do

# 		  # given (through get) range: date[start] <= task[:created_at] <= date[end]

# 		# range is not formatted correctly- end is earlier than start
# 		it 'should send back a range' do
# 			post 'task_in_range', :range => {:start => "6-16-2014", :end => "4-16-2014"}
# 			(response.status = 400).should be_true
# 		end

# 		# range is only one date
# 		it 'should send back a range' do
# 			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
# 			(response.status = 400).should be_true
# 		end

# 		# range is not formatted correctly
# 		it 'should send back a range' do
# 			post 'task_in_range', :range => {:start => "5-16-2014", :end => "5/16/2014"}
# 			(response.status = 400).should be_true
# 		end

# 	end

# end

describe 'EDIT tests' do

  context 'testing' do

    it 'should work??' do
      @controller = SessionsController.new
      post 'create', :user => {:username => "one", :password => "player"}

      @controller = TasksController.new
      post 'new', :task => {:group_id => "1", :title => "title", :finished => false, :members => [1]}
      # post 'edit_task'
      post 'edit_task', :edit => {:task_id => 1, :group_id => "1", :title => "title", :finished => false, :members => [1]}
    end

  end



end




end