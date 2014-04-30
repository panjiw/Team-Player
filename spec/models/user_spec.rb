require 'spec_helper'

describe User do

  before { @user = User.new(username: "teamplayer", firstname: "Team", lastname: "Player", email: "team@player.com",
                            password: "player", password_confirmation: "player") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
  it { should respond_to(:authenticate) }

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when firstname is not present" do
    before { @user.firstname = " " }
    it { should_not be_valid }
  end

  describe "when lastname is not present" do
    before { @user.lastname = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
    end

  describe "when password is not present" do
    before do
      @user = User.new(username: "teamplayer", firstname: "Team", lastname: "Player", email: "team@player.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end