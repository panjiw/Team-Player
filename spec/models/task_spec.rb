require 'spec_helper'
#
# TeamPlayer -- 2014
#
# Tests for the Task and TaskActor models
#

describe 'Task data:' do
  before {
    @user1 = User.new(username: "fung",
                      firstname: "Keith",
                      lastname: "Karthik",
                      email: "keith@karthik.com",
                      password: "player",
                      password_confirmation: "player")
    @user1.save
    @user2 = User.new(username: "tiffany",
                      firstname: "Linsen",
                      lastname: "Micaela",
                      email: "linsen@micaela.com",
                      password: "player",
                      password_confirmation: "player")
    @user2.save
    @user3 = User.new(username: "teamplayer",
                      firstname: "Team",
                      lastname: "Player",
                      email: "team@player.com",
                      password: "player",
                      password_confirmation: "player")
    @user3.save
    @user1.groups.create(name: "teamgroup",
                         description: "Team Player",
                         creator: @user1[:id])
    @user1.groups.first.users << @user2
    group = Group.find_by_creator(@user1[:id])
    @task = Task.new(group_id: group[:id],
                     user_id: @user1[:id],
                     title: "Test Task",
                     description: "Team Player Till",
                     due_date: Date.today,
                     finished: false)
    @task.save
    @tactor1 = TaskActor.new(task_id: @task[:id],
                             user_id: @user1[:id],
                             order: 0)
    @tactor2 = TaskActor.new(task_id: @task[:id],
                             user_id: @user2[:id],
                             order: 1)
    @tactor3 = TaskActor.new(task_id: @task[:id],
                             user_id: @user3[:id],
                             order: 2)
  }

  # Task tests
  describe Task do
    subject { @task }

    it { should respond_to(:group_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:title) }
    it { should respond_to(:description) }
    it { should respond_to(:due_date) }
    it { should respond_to(:finished_date) }
    it { should respond_to(:finished) }
    it { should be_valid }

    # Title
    describe "when title is not present" do
      before { @task.title = " " }
      it { should_not be_valid }
    end

    describe "when title is more than 255" do
      before { @task.title = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
      it { should_not be_valid }
    end

    # Group
    describe "when the group is not valid" do
      before {
        @task.group_id = 2
        @task.save
      }
      it { should_not be_valid }
    end

    # Creator
    describe "when the creator is not valid" do
      before {
        @task.user_id = 4
        @task.save
      }
      it { should_not be_valid }
    end

    describe "when the creator is not in the group" do
      before {
        @task.user_id = 3
        @task.save
      }
      it { should_not be_valid }
    end

    # Finished
    describe "when there's no finished indicator" do
      before {
        @task.finished = nil
        @task.save
      }
      it { should_not be_valid }
    end
  end

  # Task Actors test
  describe TaskActor do
    subject {@tactor1}

    it { should respond_to(:task_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:order) }
    it { should be_valid }

    # Task
    describe "when the task is not valid" do
      before {
        @tactor1.task_id = 2
        @tactor1.save
      }
      it { should_not be_valid }
    end

    # Member
    describe "when the member is not valid" do
      before {
        @tactor1.user_id = 4
        @tactor1.save
      }
      it { should_not be_valid }
    end

    describe "when the member is not in the group" do
      before {
        @tactor1.user_id = 3
        @tactor1.save
      }
      it { should_not be_valid }
    end

    # Order
    describe "when there's no order" do
      before {
        @tactor1.order = nil
        @tactor1.save
      }
      it { should_not be_valid }
    end
  end
end
