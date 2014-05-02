class StaticPagesController < ApplicationController
  def index
    if view_context.signed_in?
      redirect_to '/home'
    end
  end
  def home
    if !view_context.signed_in?
      redirect_to '/'
    end
  end
end
