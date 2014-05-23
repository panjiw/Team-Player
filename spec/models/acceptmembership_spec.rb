require 'spec_helper'

describe Acceptmembership do

    before { @mem = Acceptmembership.new(user_id: "1", group_id: "2") }

  describe "follower methods" do
    it { should respond_to(:group) }
    it { should respond_to(:user) }
  end

  describe "when user id is not present" do
    before { @mem.user_id = nil }
    it { should_not be_valid }
  end

  describe "when group id is not present" do
    before { @mem.group_id = nil }
    it { should_not be_valid }
  end

  describe "when user + group is not unique" do
    before do
      @mem.save
      @mem = Acceptmembership.new(user_id: "1", group_id: "2")
    end
    it { should_not be_valid }
  end

end
