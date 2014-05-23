#
# TeamPlayer -- 2014
#
# This file tests the UsersController functionality 
#

require 'spec_helper'

describe UsersController do

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
            (response.status == 200).should be_true
        end
    end

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
        
        before(:each) do
            post 'finduseremail', :find => {:email => "team@player.com"}
            end

        it 'should return a 200 status' do
            (response.status == 200).should be_true
        end

        it 'should return the correct information' do
            userinfo = "{\"id\":1,\"username\":\"teamplayer\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"team@player.com\"}"
            (response.body.include? userinfo).should be_true
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
            @controller = UsersController.new
            post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                              :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "taken", :firstname => "Team", :lastname => "Player", :email => "taken@player.com",
                            :password => "player", :password_confirmation => "player"}
            @controller = SessionsController.new
            post 'create',  :user => {:username => "teamplayer", :password => "player"}
            @controller = UsersController.new
        end

    context 'change password' do
        context 'all fields are correct' do

            before(:each) do
                 post 'edit_password', :edit => {:password => "player", :new_password => "newpass", :new_password_confirmation => "newpass"}
                end
            
            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

            it 'should have the correct password' do
                @controller = SessionsController.new
                delete 'destroy'
                post 'create', :user => {:username => "teamplayer", :password => "newpass"}
                (response.status == 200).should be_true
            end
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

        context 'when all information is correct' do
        
            before(:each) do
                post 'edit_username', :edit => {:password => "player", :username => "newname"}
            end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

            it 'should have the correct new username' do
                @controller = SessionsController.new
                get 'user'

                userinfo = "{\"username\":\"newname\",\"firstname\":\"Team\",\"lastname\":\"Player\","
                (response.body.include? userinfo).should be_true
            end

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

        context 'input information is correct' do

            before(:each) do
                post 'edit_name', :edit => {:password => "player", :firstname => "newname", :lastname => "newlastname"}
                end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

            it 'should edit the user information' do
                 @controller = SessionsController.new
                 get 'user'
                 userinfo = "{\"username\":\"teamplayer\",\"firstname\":\"newname\",\"lastname\":\"newlastname\","
                 (response.body.include? userinfo).should be_true
            end
        end

        it 'should not change the names because password does not match' do
            post 'edit_name', :edit => {:password => "hahahahah", :firstname => "newname", :lastname => "newlastname"}
            (response.status == 400).should be_true
        end

        end

    context 'change email' do

        context 'when information is correct' do

            before(:each) do
                post 'edit_email', :edit => {:password => "player", :email => "newname@gmail.com"}
                end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

            it 'should have the new email' do
                get 'finduseremail', :find => {:email => "newname@gmail.com"}
                userinfo = "{\"id\":1,\"username\":\"teamplayer\",\"firstname\":\"Team\",\"lastname\":\"Player\",\"email\":\"newname@gmail.com\"}"
                (response.body.include? userinfo).should be_true
            end

        end

        it 'should not change the email because password doesnt match' do
            post 'edit_email', :edit => {:password => "hahahahah", :email => "newname@gmail.com"}
            (response.status == 400).should be_true
            end

        it 'should not change the email because email already exists' do
            post 'edit_email', :edit => {:password => "player", :email => "taken@player.com"}
            (response.status == 400).should be_true
            end

        it 'should not change the email because the email is invalid' do
             post 'edit_email', :edit => {:password => "player", :email => "lol"}
            (response.status == 400).should be_true
        end

    end



    end
 end




end