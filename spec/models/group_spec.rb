require 'spec_helper'
# Tests for the user model (Rep Inv tests)
describe Group do

  before { @group = Group.new(name: "teamplayer", description: "group management", creator: "1")}

  subject { @group }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:creator) }
  
  # do we need these? membership?
  it { should respond_to(:users) }
  it { should respond_to(:memberships) }

  # Name
  describe "when Name is not present" do
    before { @group.name = " " }
    it { should_not be_valid }
  end

  describe "when name is more than 64" do
    before { @group.name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
    it { should_not be_valid }
  end

  # creator
  describe "when creator is not present" do
    before { @group.creator = " " }
    it { should_not be_valid }
  end
end
