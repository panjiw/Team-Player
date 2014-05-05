require 'spec_helper'

describe Membership do
  describe "follower methods" do
    it { should respond_to(:group) }
    it { should respond_to(:user) }
    # its(:group) { should eq group }
    # its(:user) { should eq user }
  end

  #describe "when user id is not present" do
  #  before { membership.user_id = nil }
  #  it { should_not be_valid }
  #end

  #describe "when group id is not present" do
  #  before { membership.group_id = nil }
  #  it { should_not be_valid }
  #end

end
