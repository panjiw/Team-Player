require 'spec_helper'
#
# TeamPlayer -- 2014
#
# Tests for the Bill and BillActor models
#

describe 'Bill data:' do
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
    @bill = Bill.new(group_id: group[:id],
                     user_id: @user1[:id],
                     title: "Test Bill",
                     description: "Team Player Bill",
                     due_date: Date.today,
                     total_due: 100)
    @bill.save
    @bactor1 = BillActor.new(bill_id: @bill[:id],
                             user_id: @user1[:id],
                             due: 25,
                             paid: false)
    @bactor2 = BillActor.new(bill_id: @bill[:id],
                             user_id: @user2[:id],
                             due: 75,
                             paid: false)
    @bactor3 = BillActor.new(bill_id: @bill[:id],
                             user_id: @user3[:id],
                             due: 75,
                             paid: false)
  }

  # Bill tests
  describe Bill do
    subject { @bill }

    it { should respond_to(:group_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:title) }
    it { should respond_to(:description) }
    it { should respond_to(:due_date) }
    it { should respond_to(:total_due) }
    it { should be_valid }

    # Title
    describe "when title is not present" do
      before { @bill.title = " " }
      it { should_not be_valid }
    end

    describe "when title is more than 255" do
      before { @bill.title = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
      it { should_not be_valid }
    end

    # Group
    describe "when the group is not valid" do
      before {
        @bill.group_id = 2
        @bill.save
      }
      it { should_not be_valid }
    end

    # Creator
    describe "when the creator is not valid" do
      before {
        @bill.user_id = 4
        @bill.save
      }
      it { should_not be_valid }
    end

    describe "when the creator is not in the group" do
      before {
        @bill.user_id = 3
        @bill.save
      }
      it { should_not be_valid }
    end

    # Total Due
    describe "when total due is negative" do
      before { @bill.total_due = -1 }
      it { should_not be_valid }
    end
  end

  # Bill Actors test
  describe BillActor do
    subject {@bactor1}

    it { should respond_to(:bill_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:due) }
    it { should respond_to(:paid_date) }
    it { should respond_to(:paid) }
    it { should be_valid }

    # Bill
    describe "when the bill is not valid" do
      before {
        @bactor1.bill_id = 2
        @bactor1.save
      }
      it { should_not be_valid }
    end

    # Member
    describe "when the member is not valid" do
      before {
        @bactor1.user_id = 4
        @bactor1.save
      }
      it { should_not be_valid }
    end

    describe "when the member is not in the group" do
      before {
        @bactor1.user_id = 3
        @bactor1.save
      }
      it { should_not be_valid }
    end

    # Total Due
    describe "when due is negative" do
      before { @bactor1.due = -1 }
      it { should_not be_valid }
    end
  end
end