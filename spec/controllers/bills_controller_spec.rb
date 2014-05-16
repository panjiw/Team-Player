#
# TeamPlayer -- 2014
#
# This file tests the BillsController functionality 
#

require 'spec_helper'

describe BillsController do

  # match '/create_bill', to: 'bills#new', via: 'post'
  # match '/get_bills', to: 'bills#get_all',   via: 'get'

#tests for new
describe "testing NEW" do

	before(:each) do
		@controller = UsersController.new
		post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        	:password => "player", :password_confirmation => "player"}
        @controller = BillsController.new
		end

	# tests creating a bill when user isn't logged in
	context 'user is not signed in' do
		# it 'should not show bills' do
		# 	post 'new'
		# 	(response.body.include? "redirected").should be_true
		# 	end
		end

	# test creating a split bill with one user
	context 'the user creates a bill with one user' do
		
		before(:each) do
			@controller = SessionsController.new
        	post 'create', :user => {:username => "takenname", :password => "player"}
        	@controller = BillsController.new
			end

		# group_id: params[:bill][:group_id],
  #                      user_id: view_context.current_user[:id],
  #                      title: params[:bill][:title],
  #                      description: params[:bill][:description],
  #                      due_date: params[:bill][:due_date],
  #                      total_due: params[:bill][:total_due])


		it 'should split correctly' do
			# post 'new', :bill => {:title => "title", :description => "description", :due_date => "date?", :total_due => 10, :group_id => 1, :members => [1]}



			end
	end


	# tests creating a split bill with uneven split

	# tests creating a bill when prices do not add up

	# tests creating a bill when prices add up and only one person

	# tests creating a bill when prices add up and more than one person

	# tests if bill with multiple people with correct total and splitting is added

end

#tests for getbill
describe "testing getbill" do	
	# tests what is returned when the user isn't signed in
	context 'user is not signed in' do
		it 'should not show bills' do
			get 'get_bills'
			(response.body.include? "redirected").should be_true
		end
	end

	# tests what is returned when user is not signed in
	context 'user is signed in' do
		it 'should show ok json query' do
			@controller = UsersController.new
			post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
        		 :password => "player", :password_confirmation => "player"}
            
        	@controller = SessionsController.new
        	post 'create', :user => {:username => "takenname", :password => "player"}
	
        	@controller = BillsController.new

        	get 'get_bills'
        	(response.body.include? "bill").should be_true
        	(response.body.include? "OK").should be_true
		end
	end

end


end