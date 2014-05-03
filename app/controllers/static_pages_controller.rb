# Controls the 2 pages
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
