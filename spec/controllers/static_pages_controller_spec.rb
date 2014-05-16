#
# TeamPlayer -- 2014
#
# This file tests the StaticPagesController functionality 
#

require 'spec_helper'

describe StaticPagesController do

# match '/',            to: 'static_pages#index',  via: 'get'
#   match '/index',       to: 'static_pages#index',  via: 'get'
#   match '/home',        to: 'static_pages#home',   via: 'get'

    before(:each) do
        @controller = UsersController.new
		post 'create', :user => {:username => "takenname", :firstname => "Team", :lastname => "Player", :email => "team@player.com",
            :password => "player", :password_confirmation => "player"}
            
        @controller = SessionsController.new
        post 'create', :user => {:username => "takenname", :password => "player"}

        @controller = StaticPagesController.new
    end

# home
	describe "testing HOME" do
		
		context 'user is not signed in' do
			it 'should redirect the user' do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = StaticPagesController.new
				get 'home'
				(response.body.include? "redirected").should be_true
				end
			end

		context 'user is signed in' do
			it 'should go to the home page' do
				get 'home'
				(response.status == 200).should be_true
				end
			end

	end

# index
	describe "testing INDEX" do
		
		context 'user is not signed in' do
			it 'should go to the index page' do
				@controller = SessionsController.new
				delete 'destroy'
				@controller = StaticPagesController.new
				get 'index'
				(response.status == 200).should be_true
				end
			end

		context 'user is signed in' do
			it 'should reedirct to the home page' do 
				get 'index'
				(response.body.include? "redirected").should be_true
			end
		end

	end

# help
# no functionality provided; no need to test


end