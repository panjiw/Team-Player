#
# TeamPlayer -- 2014
#
# This file tests the UsersController functionality 
#

require 'spec_helper'

describe UsersController do

# tests if creates a valid user
describe "GET show" do
    before(:each) do
      @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
    end

    context 'creating one user' do
    	it 'should add one user' do
			@user.should be_valid
		end
	end	

end
	
# tests than, when attempting to create an invalid user, throws an error
describe "adding an incorrect user" do
	
    context 'creating mismatching passwords user' do
    	it 'should throw an error' do
    		lambda { User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "notworking" }.should raise_error
		end
	end	

    context 'creating too short password user' do
        it 'should throw an error' do
            lambda { User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "no", :password_confirmation => "no" }.should raise_error
        end
    end 

    context 'email already in database' do
        it 'should throw an error' do
        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
        lambda { User.create! :username => "newname", :firstname => "New", :lastname => "Name", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"}.should raise_error
        end
    end

    context 'username already in database' do
        it 'should throw an error' do
        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                            :password => "player", :password_confirmation => "player"
        lambda { User.create! :username => "teamplayer", :firstname => "New", :lastname => "Name", :email => "new@email.com",
                            :password => "player", :password_confirmation => "player"}.should raise_error
        end
    end

end

# tests the controller's create method
describe "CREATE new" do

    before(:each) do
        post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                             :password => "player", :password_confirmation => "player"}
    end

    # tests when every value is correct that create works
    context 'every value is correct' do
        it 'should create user ' do
            post 'create', :user => {:username => "newusername", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "player", :password_confirmation => "player"}
            (response.body.include? "token").should be_true
            (response.status == 200).should be_true
        end
    end

    # WRITE NEW CHECKS

    # test when username is already in database that create does not work
    context 'username already in database' do
        it 'should not create user ' do
            post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "no@player.com",
                             :password => "player", :password_confirmation => "player"}
            (response.status == 400).should be_true
        end 
    end

    # tests when email is already in database that create does not work
    context 'email is already in database' do
        it 'should not create user ' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                             :password => "player", :password_confirmation => "player"}
            
            (response.status == 400).should be_true        
            end 
    end

    # tests when password size is not long enough that create does not work
    context 'password not long enough' do
        it 'should not create user' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "play", :password_confirmation => "play"}
            
            (response.status == 400).should be_true
        end 
    end

    # tests when passwords do not match create does not work
    context 'passwords do not match' do
        it 'should not create user ' do
            post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                             :password => "playrrrrrrr", :password_confirmation => "playeeeee"}
            
            (response.status == 400).should be_true
        end 
    end

end

describe "UPDATE user" do
    before(:each) do
        post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "taken@email.com",
                             :password => "player", :password_confirmation => "player"}
   
        post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                             :password => "player", :password_confirmation => "player"}

    end

    #checks if update runs correctly when username is changed
    context 'all input correct username changed' do
        it 'should update user information' do
            post 'update', :user => {:username => "newname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 200).should be_true
        end
    end

    #checks if update runs correctly when firstname is changed
    context 'it should update users firstname' do
        it 'should update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "newname", :lastname => "Player", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 200).should be_true
        end
    end

    #checks if update runs correctly when lastname is changed
    context 'it should update users lastname' do
        it 'should update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "newname", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 200).should be_true
        end
    end

    #checks if update runs correctly when email is changed
    context 'it should update users email' do
        it 'should update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 200).should be_true
        end
    end

    #checks if update runs correctly when password is changed
    context 'it should update users password' do
        it 'should update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "newplayer", :password_confirmation => "newplayer"}
            (response.status == 200).should be_true
        end
    end

    #checks if update throws an error when passwords don't match
    context 'it should not update users password' do
        it 'should not update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "players", :password_confirmation => "player"}
            (response.status == 400).should be_true
        end
    end

    #checks if update throws an error when passwords are too small
    context 'it should not update users password' do
        it 'should not update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "play", :password_confirmation => "play"}
            (response.status == 400).should be_true
        end
    end

    #checks if update throws an error when username already exists
    context 'it should update user' do
        it 'should update user information' do
            post 'update', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 400).should be_true
        end
    end

    #checks if update throws an error when email already exists
   context 'it should update user' do
        it 'should update user information' do
            post 'update', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "taken@email.com",
            :password => "player", :password_confirmation => "player"}
            (response.status == 400).should be_true
        end
    end
end


# #viewgroup-> give all groups login user is in, and for each group includes all
#   # t he users of that group, excluding private infos
#   def viewgroup
#     groups = current_user.groups
#     render :json => groups.to_json(:include => [:users => {:except => [:created_at, :updated_at, 
#             :password_digest, :remember_token]}]), :status => 200
#   end

# tests for viewgroup
describe 'viewgroup' do
    before(:each) do
        # user only in self group
        @user = User.create! :username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in group and group with self
        @user = User.create! :username => "two", :firstname => "Team", :lastname => "Player", :email => "two@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in group and group created themself
        @user = User.create! :username => "three", :firstname => "Team", :lastname => "Player", :email => "three@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in group and group created by someone else
        @user = User.create! :username => "four", :firstname => "Team", :lastname => "Player", :email => "four@player.com",
                              :password => "player", :password_confirmation => "player"

        # user in three groups
        @user = User.create! :username => "five", :firstname => "Team", :lastname => "Player", :email => "five@player.com",
                              :password => "player", :password_confirmation => "player"
        @user = User.create! :username => "six", :firstname => "Team", :lastname => "Player", :email => "six@player.com",
                              :password => "player", :password_confirmation => "player"
        @user = User.create! :username => "seven", :firstname => "Team", :lastname => "Player", :email => "seven@player.com",
                              :password => "player", :password_confirmation => "player"

        @controller = SessionsController.new
        post 'create', :user => {:username => "two", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "2 group", :description => "two desc"}

        @controller = SessionsController.new
        delete 'destroy'
        post 'create', :user => {:username => "three", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "34 group", :description => "34 desc"}, :add => {:members => [4]}

        @controller = SessionsController.new
        delete 'destroy'
        post 'create', :user => {:username => "five", :password => "player"}

        @controller = GroupsController.new
        post 'create', :group => {:name => "567 group", :description => "567 desc"}, :add => {:members => [6,7]}
        post 'create', :group => {:name => "567 new group", :description => "567 desc"}, :add => {:members => [6,7]}        

        @controller = SessionsController.new
        delete 'destroy'
        
        @controller = UsersController.new

        end

        context 'the user is in a self group' do                
                before(:each) do
                    @controller = SessionsController.new
                    post 'create', :user => {:username => "one", :password => "player"}

                    @controller = UsersController.new
                    get 'viewgroup'
                    end

                it 'should return 200' do
                    (response.status == 200).should be_true
                    end

                it 'should return a blank string' do
                    (response.body.include? "[]").should be_true
                    end
        end

        context 'the user is one group with one person and one self group' do
            before(:each) do
                @controller = SessionsController.new
                post 'create', :user => {:username => "two", :password => "player"}

                @controller = UsersController.new
                get 'viewgroup'
            end

            it 'should return 200' do
                (response.status == 200).should be_true
                end

            # test for group info
            it 'should return twos groups user info' do
                groupinfo = "[{\"id\":1,\"name\":\"2 group\",\"description\":\"two desc\",\"creator\":2,"
                (response.body.include? groupinfo).should be_true
                end

            # test for two's info
            it 'should return twos user info' do
                twosinfo = "\"id\":2,\"username\":\"two\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"two@player.com\""
                (response.body.include? twosinfo).should be_true
                end
        end

        context 'the user is one group they created with two people and one self group' do
                before(:each) do
                    @controller = SessionsController.new
                    post 'create', :user => {:username => "three", :password => "player"}

                    @controller = UsersController.new
                    get 'viewgroup'
                    end

                it 'should return 200' do
                    (response.status == 200).should be_true
                    end

                # test for group info
                it 'should return twos groups user info' do
                    groupinfo = "[{\"id\":2,\"name\":\"34 group\",\"description\":\"34 desc\",\"creator\":3,"
                    (response.body.include? groupinfo).should be_true
                    end

                # test for three's info
                it 'should return threes user info' do
                    threesinfo = "\"id\":3,\"username\":\"three\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"three@player.com\""
                    (response.body.include? threesinfo).should be_true
                    end

                # test for four's info
                it 'should return twos user info' do
                    foursinfo = "\"id\":4,\"username\":\"four\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"four@player.com\""
                    (response.body.include? foursinfo).should be_true
                    end            
        end

        context 'the user is one group they did not create with two people and one self group' do
            before(:each) do
                @controller = SessionsController.new
                post 'create', :user => {:username => "four", :password => "player"}

                @controller = UsersController.new
                get 'viewgroup'

            end

            it 'should return 200' do
                    (response.status == 200).should be_true
                    end

                # test for group info
                it 'should return twos groups user info' do
                    groupinfo = "[{\"id\":2,\"name\":\"34 group\",\"description\":\"34 desc\",\"creator\":3,"
                    (response.body.include? groupinfo).should be_true
                    end

                # test for three's info
                it 'should return threes user info' do
                    threesinfo = "\"id\":3,\"username\":\"three\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"three@player.com\""
                    (response.body.include? threesinfo).should be_true
                    end

                # test for four's info
                it 'should return twos user info' do
                    foursinfo = "\"id\":4,\"username\":\"four\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"four@player.com\""
                    (response.body.include? foursinfo).should be_true
                    end

        end

        context 'the user is two groups they created with three people and one self group' do
            before(:each) do
                @controller = SessionsController.new
                post 'create', :user => {:username => "five", :password => "player"}

                @controller = UsersController.new
                get 'viewgroup'
            end

                it 'should return 200' do
                    (response.status == 200).should be_true
                    end

                # test for group info
                it 'should return twos groups user info' do
                    groupinfo = "[{\"id\":3,\"name\":\"567 group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? groupinfo).should be_true
                    end

                # test for new group info
                it 'should return twos groups user info' do
                    newgroupinfo = "\"id\":4,\"name\":\"567 new group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? newgroupinfo).should be_true
                    end

                # test for five's info
                it 'should return fives user info' do
                    fivesinfo = "\"id\":5,\"username\":\"five\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"five@player.com\""
                    (response.body.include? fivesinfo).should be_true
                    end

                # test for six's info
                it 'should return sixs user info' do
                    sixsinfo = "\"id\":6,\"username\":\"six\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"six@player.com\""
                    (response.body.include? sixsinfo).should be_true
                    end

                # test for seven's info
                it 'should return sevens user info' do
                    sevensinfo = "\"id\":7,\"username\":\"seven\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"seven@player.com\""
                    (response.body.include? sevensinfo).should be_true
                    end

        end

        context 'the user is two groups they did not create with three people and one self group' do
            before(:each) do
                @controller = SessionsController.new
                post 'create', :user => {:username => "six", :password => "player"}

                @controller = UsersController.new
                get 'viewgroup'
            end

            # test for group info
                it 'should return twos groups user info' do
                    groupinfo = "[{\"id\":3,\"name\":\"567 group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? groupinfo).should be_true
                    end

                # test for new group info
                it 'should return twos groups user info' do
                    newgroupinfo = "\"id\":4,\"name\":\"567 new group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? newgroupinfo).should be_true
                    end

                # test for five's info
                it 'should return fives user info' do
                    fivesinfo = "\"id\":5,\"username\":\"five\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"five@player.com\""
                    (response.body.include? fivesinfo).should be_true
                    end

                # test for six's info
                it 'should return sixs user info' do
                    sixsinfo = "\"id\":6,\"username\":\"six\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"six@player.com\""
                    (response.body.include? sixsinfo).should be_true
                    end

                # test for seven's info
                it 'should return sevens user info' do
                    sevensinfo = "\"id\":7,\"username\":\"seven\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"seven@player.com\""
                    (response.body.include? sevensinfo).should be_true
                    end

        end

end

# tests for finduseremail 
describe "finduseremail" do
    
    before(:each) do
        @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "player"
        end

    context 'user exists' do
        it 'should find user' do
            post 'finduseremail', :find => {:email => "team@player.com"}
            (response.body.include? "Team").should be_true
            (response.body.include? "Player").should be_true
            (response.body.include? "1").should be_true
            (response.body.include? "teamplayer").should be_true
            (response.body.include? "team@player.com").should be_true
            (response.status == 200).should be_true
            end
        end

    context 'user does not exist' do
        it 'should not find user' do
            post 'finduseremail', :find => {:email => "no@no.com"}
            (response.status == 400).should be_true
            end
        end
    end

# edit
describe 'EDIT tests' do
    
    before(:each) do
            @user = User.create! :username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "player"
            @user = User.create! :username => "taken", :firstname => "Team", :lastname => "Player", :email => "taken@player.com",
                            :password => "player", :password_confirmation => "player"
            @controller = SessionsController.new
            post 'create',  :user => {:username => "teamplayer", :password => "player"}
            @controller = UsersController.new
        end

    context 'change password' do
        it 'should change the password' do
            post 'edit_password', :edit => {:password => "player", :new_password => "newpass", :new_password_confirmation => "newpass"}
            (response.status == 200).should be_true
        end 

        it 'should not change the password because old password doesnt match' do
            post 'edit_password', :edit => {:password => "notthispassword", :new_password => "newpass", :new_password_confirmation => "newpass"}
            (response.status == 400).should be_true
        end

        it 'should not change the password because new passwords dont match' do
            post 'edit_password', :edit => {:password => "player", :new_password => "newpass", :new_password_confirmation => "hahahnope"}
            (response.status == 400).should be_true
        end

        it 'should not change the password because new password is too short' do
            post 'edit_password', :edit => {:password => "player", :new_password => "new", :new_password_confirmation => "new"}
            (response.status == 400).should be_true
        end

    context 'change username' do

        it 'should change the username' do
            post 'edit_username', :edit => {:password => "player", :username => "newname"}
            (response.status == 200).should be_true
            end

        it 'should not change the username because password doesnt match' do
            post 'edit_username', :edit => {:password => "hahahahah", :username => "newname"}
            (response.status == 400).should be_true
            end

        it 'should not change the username because username already exists' do
            post 'edit_username', :edit => {:password => "player", :username => "taken"}
            (response.status == 400).should be_true
            end

        end

    context 'change names' do

        it 'should change the names' do
            post 'edit_name', :edit => {:password => "player", :firstname => "newname", :lastname => "newlastname"}
            (response.status == 200).should be_true
        end

        it 'should not change the names because password does not match' do
            post 'edit_name', :edit => {:password => "hahahahah", :firstname => "newname", :lastname => "newlastname"}
            (response.status == 400).should be_true
        end

        end

    context 'change email' do

        it 'should change the username' do
            post 'edit_email', :edit => {:password => "player", :email => "newname@gmail.com"}
            (response.status == 200).should be_true
            end

        it 'should not change the username because password doesnt match' do
            post 'edit_email', :edit => {:password => "hahahahah", :email => "newname@gmail.com"}
            (response.status == 400).should be_true
            end

        it 'should not change the username because username already exists' do
            post 'edit_email', :edit => {:password => "player", :email => "taken@player.com"}
            (response.status == 400).should be_true
            end


    end



    end
 end




end