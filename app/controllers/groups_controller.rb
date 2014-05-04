class GroupsController < ApplicationController
  before_action :signed_in_user

  #  $.post("/create_group",
  #  {
  #    "group[title]": fname,
  #    "group[description]": lname,
  ###    "group[creator]": "1",
  #  })

  def create
    @group = Group.new(group_params)
      #current_user.groups.build(group_params)
    if @group.save
      # render @group.json :status => 205
      render :json => {:groups =>  @group}
    else
      render :json => {:errors => @group.errors.full_messages}, :status => 400
    end
  end

  def destroy
  end

  private

    def group_params
      # params[:creator] = current_user.id
      params.require(:group).permit(:title, :description, :creator)
    end
end
