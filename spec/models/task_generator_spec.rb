require 'spec_helper'
#
# TeamPlayer -- 2014
#
# Tests for the Task generator and Task generator actor models
#

describe 'Task Generator data:' do
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
    @task_generator = TaskGenerator.new(group_id: group[:id],
                              user_id: @user1[:id],
                              title: "Test Task",
                              description: "Team Player Till",
                              cycle: true,
                              finished: false)
    @task_generator[:repeat_days] = {}
    day = 1
    while day <= 7
      @task_generator[:repeat_days][day] = true
      day += 1
    end
    @task_generator.save
    @tactor1 = TaskActor.new(task_id: @task_generator[:id],
                             user_id: @user1[:id],
                             order: 0)
    @tactor2 = TaskActor.new(task_id: @task_generator[:id],
                             user_id: @user2[:id],
                             order: 1)
    @tactor3 = TaskActor.new(task_id: @task_generator[:id],
                             user_id: @user3[:id],
                             order: 2)
  }

  describe TaskGenerator do
    subject { @task_generator }

    it { should respond_to(:group_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:title) }
    it { should respond_to(:description) }
    it { should respond_to(:finished_date) }
    it { should respond_to(:finished) }
    it { should respond_to(:repeat_days) }
    it { should respond_to(:cycle) }
    it { should respond_to(:current_task_id) }
    it { should respond_to(:due_date) }
    it { should be_valid }

    # Title
    describe "when title is not present" do
      before { @task_generator.title = " " }
      it { should_not be_valid }
    end

    describe "when title is more than 255" do
      before { @task_generator.title = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
      it { should_not be_valid }
    end

    # Group
    describe "when the group is not valid" do
      before {
        @task_generator.group_id = 2
        @task_generator.save
      }
      it { should_not be_valid }
    end

    # Creator
    describe "when the creator is not valid" do
      before {
        @task_generator.user_id = 4
        @task_generator.save
      }
      it { should_not be_valid }
    end

    describe "when the creator is not in the group" do
      before {
        @task_generator.user_id = 3
        @task_generator.save
      }
      it { should_not be_valid }
    end

    # Finished
    describe "when there's no finished indicator" do
      before {
        @task_generator.finished = nil
        @task_generator.save
      }
      it { should_not be_valid }
    end

    # Cycle
    describe "when there's no cycle indicator" do
      before {
        @task_generator.cycle = nil
        @task_generator.save
      }
      it { should_not be_valid }
    end
  end
  describe TaskGeneratorActor do

  end
end
