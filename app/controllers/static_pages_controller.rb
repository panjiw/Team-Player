#
# TeamPlayer -- 2014
#
# This file deals with redirecting the user between
# the home (main page) or login page when the user
# signs in (redirects to home page) or signs out
# (redirects back to the login page
class StaticPagesController < ApplicationController
  # Go to home if signed in
  def index
    if view_context.signed_in?
      redirect_to '/home'
    end
  end

  # Go to index if signed out
  def home
    if !view_context.signed_in?
      redirect_to '/'
    end
  end

  def help
  end
end
