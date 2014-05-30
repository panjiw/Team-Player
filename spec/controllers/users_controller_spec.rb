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

            #TODO: check if return values are correct

        end

        # test when username is already in database that create does not work
        context 'username already in database' do

            before(:each) do
                post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "no@player.com",
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should display the correct error message' do
                 errormessage = "[\"Username has already been taken\"]"
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end
             
        end

        # tests when email is already in database that create does not work
        context 'email is already in database' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "[\"Email has already been taken\"]"
                (response.body.include? errormessage).should be_true
            end            

            it 'should return a 400 status' do
                (response.status == 400).should be_true        
            end 

        end

        # tests when password size is not long enough that create does not work
        context 'password not long enough' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                                 :password => "play", :password_confirmation => "play"}
               end
               
            it 'should return the correct error message' do
                errormessage = "[\"Password is too short (minimum is 6 characters)\"]"
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        # tests when passwords do not match create does not work
        context 'passwords do not match' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                                 :password => "playrrrrrrr", :password_confirmation => "playeeeee"}
            end

            it 'should return the correct error message' do
                errormessage = "[\"Password confirmation doesn't match Password\"]"
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        context 'username is nil' do

            before(:each) do
                post 'create', :user => {:username => nil, :firstname => "Team", :lastname => "Player", :email => "new@player.com",
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "\"Username can't be blank\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return the correct error message' do
                errormessage = "\"Username is invalid\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        context 'firstname is nil' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => nil, :lastname => "Player", :email => "new@player.com",
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "\"Firstname can't be blank\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        context 'lastname is nil' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => nil, :email => "new@player.com",
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "\"Lastname can't be blank\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        context 'email is nil' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => nil,
                                 :password => "player", :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "\"Email can't be blank\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return the correct error message' do
                errormessage = "\"Email is invalid\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end


        context 'password is nil' do

            before(:each) do
                post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                                 :password => nil, :password_confirmation => "player"}
            end

            it 'should return the correct error message' do
                errormessage = "\"Password can't be blank\""
                (response.body.include? errormessage).should be_true
            end

            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end 
        
        end

        #TODO

        # context 'password confirmation is nil' do

        #     before(:each) do
        #         post 'create', :user => {:username => "tp", :firstname => "Team", :lastname => "Player", :email => "new@player.com",
        #                          :password => "player", :password_confirmation => nil}
        #     end

        #     it 'should return the correct error message' do
        #         errormessage = "\"Password confirmation can't be blank\""
        #         puts response.body
        #         (response.body.include? errormessage).should be_true
        #     end

        #     it 'should return a 400 status' do
        #         (response.status == 400).should be_true
        #     end 
        
        # end

    end


    # TODO: ERROR MESSAGES

    # tests for viewgroup
    describe 'viewgroup' do

        before(:each) do
            # user only in self group
            @controller = UsersController.new
            post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
                                  :password => "player", :password_confirmation => "player"}

            # user in group and group with self
            post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "two@player.com",
                                  :password => "player", :password_confirmation => "player"}

            # user in group and group created themself
            post 'create', :user => {:username => "three", :firstname => "Team", :lastname => "Player", :email => "three@player.com",
                                  :password => "player", :password_confirmation => "player"}

            # user in group and group created by someone else
            post 'create', :user => {:username => "four", :firstname => "Team", :lastname => "Player", :email => "four@player.com",
                                  :password => "player", :password_confirmation => "player"}

            # user in three groups
            post 'create', :user => {:username => "five", :firstname => "Team", :lastname => "Player", :email => "five@player.com",
                                  :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "six", :firstname => "Team", :lastname => "Player", :email => "six@player.com",
                                  :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "seven", :firstname => "Team", :lastname => "Player", :email => "seven@player.com",
                                  :password => "player", :password_confirmation => "player"}

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

                it 'checks group info' do
                    groupinfo = "[{\"id\":1,"
                    (response.body.include? groupinfo).should be_true
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
                    groupinfo = "\"id\":8,\"name\":\"2 group\",\"description\":\"two desc\",\"creator\":2,"
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
                    groupinfo = "\"id\":9,\"name\":\"34 group\",\"description\":\"34 desc\",\"creator\":3,"
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
                    groupinfo = "\"id\":9,\"name\":\"34 group\",\"description\":\"34 desc\",\"creator\":3,"
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
                    groupinfo = "\"id\":10,\"name\":\"567 group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? groupinfo).should be_true
                end

                # test for new group info
                it 'should return twos groups user info' do
                    newgroupinfo = "\"id\":11,\"name\":\"567 new group\",\"description\":\"567 desc\",\"creator\":5,"
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
                    groupinfo = "\"id\":10,\"name\":\"567 group\",\"description\":\"567 desc\",\"creator\":5,"
                    (response.body.include? groupinfo).should be_true
                end

                # test for new group info
                it 'should return twos groups user info' do
                    newgroupinfo = "\"id\":11,\"name\":\"567 new group\",\"description\":\"567 desc\",\"creator\":5,"
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
        
        #TODO: user is not signed in

        before(:each) do
            @controller = UsersController.new
            post 'create', :user => {:username => "teamplayer", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
                                  :password => "player", :password_confirmation => "player"}
            @controller = SessionsController.new
            post 'create', :user => {:username => "teamplayer", :password => "player"}
            @controller = UsersController.new
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

            before(:each) do
                post 'finduseremail', :find => {:email => "no@no.com"}
            end

            it 'shoudl return the correct error message' do
                 # currently no error message?
            end
               
            it 'should return a 400 status' do
                (response.status == 400).should be_true
            end
        end

        context 'user is not signed in' do

            before(:each) do
                @controller = SessionsController.new
                delete 'destroy'
                @controller = UsersController.new
                post 'finduseremail', :find => {:email => "team@player.com"}
            end

            it 'should return a 302 status' do
                (response.status == 302).should be_true
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

                # TODO: check response (may need to reformat)

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

            it 'should not change the password because new password is nil' do
                post 'edit_password', :edit => {:password => "player", :new_password => nil, :new_password_confirmation => "newpass"}
                (response.status == 400).should be_true
            end

             it 'should not change the password because passed a nil value in password' do
                post 'edit_password', :edit => {:password => nil, :new_password => "new", :new_password_confirmation => "new"}
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

            it 'should not change the username because password is nil' do
                post 'edit_username', :edit => {:password => nil, :username => "newname"}
                (response.status == 400).should be_true
            end

            it 'should not change the username because username is nil' do
                post 'edit_username', :edit => {:password => "player", :username => nil}
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

            it 'should not change the name because its passed a nil password value' do
                post 'edit_name', :edit => {:password => nil, :firstname => "newname", :lastname => "newlastname"}
                (response.status == 400).should be_true
            end

            it 'should not change the name because its passed a nil firstname value' do
                post 'edit_name', :edit => {:password => "player", :firstname => nil, :lastname => "newlastname"}
                (response.status == 400).should be_true
            end

            it 'should not change the name because its passed a nil firstname value' do
                post 'edit_name', :edit => {:password => "player", :firstname => "newname", :lastname => nil}
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

            it 'should not change the email because the email is nil' do
                 post 'edit_email', :edit => {:password => "player", :email => nil}
                (response.status == 400).should be_true
            end

            it 'should not change the email because the password is nil' do
                 post 'edit_email', :edit => {:password => nil, :email => "newemail@email.com"}
                (response.status == 400).should be_true
            end

        end
    end
    end

    #TODO: VIEWPENDINGGROUPS
    describe 'VIEWPENDINGGROUPS tests' do

        before(:each) do
            post 'create', :user => {:username => "one", :firstname => "Team", :lastname => "Player", :email => "one@player.com",
                :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "two", :firstname => "Team", :lastname => "Player", :email => "two@player.com",
                :password => "player", :password_confirmation => "player"}
            post 'create', :user => {:username => "three", :firstname => "Team", :lastname => "Player", :email => "three@player.com",
                :password => "player", :password_confirmation => "player"}
            @controller = SessionsController.new
            post 'create', :user => {:username => "two", :password => "player"}
            @controller = GroupsController.new
            post 'create', :group => {:name => "group one", :description => "desc"}
            post 'create', :group => {:name => "group two", :description => "desc", :add => {:members => [3]}}
            @controller = UsersController.new
        end

        # # not logged in
        # context 'the user is not logged in' do

        #     before(:each) do
        #         @controller = SessionsController.new
        #         delete 'destroy'
        #         @controller = UsersController.new
        #         get 'viewpendinggroups'
        #     end

        #     it 'should return a 302 status' do
        #         (response.status == 302).should be_true
        #     end

        # end


        # not in any pending groups
        context 'the user is not in any pending groups or groups' do

            before(:each) do
                @controller = SessionsController.new
                delete 'destroy'
                post 'create', :user => {:username => "one", :password => "player"}
                @controller = UsersController.new
                get 'viewpendinggroups'
            end

            it 'should return the correct information' do
                (response.body.include? "[]").should be_true
            end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

        end

        # in groups but not pending groups
        context 'the user is not in any pending groups or groups' do

            before(:each) do
                get 'viewpendinggroups'
            end

            it 'should return the correct information' do
                (response.body.include? "[]").should be_true
            end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

        end

        context 'the user is in one pending group' do

            before(:each) do
                @controller = SessionsController.new
                delete 'destroy'
                post 'create', :user => {:username => "three", :password => "player"}
                @controller = UsersController.new
                get 'viewpendinggroups'
            end

            it 'should return the correct information' do
                (response.body.include? "[]").should be_true
            end

            it 'should return a 200 status' do
                (response.status == 200).should be_true
            end

        end


    end

end