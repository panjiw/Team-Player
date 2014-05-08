class GroupsController < ApplicationController
  before_action :signed_in_user

  # create a new group and add current_user to group + creator
  def create
    @group = current_user.groups.build(group_params)
    if @group.save
      # link membership association between new group and creator
      @group.users << current_user

      # for each members in paramter, add to group
      merror = ""
      @members = params[:add][:members]
      @members.each do |id|
        if(User.exists?(id) && id != current_user.id.to_s)
	  @group.users << User.find(id)
        else
	  merror << " " + id << " "
        end
      end

      # if one of the user is not found shows who (merror) and status 206 otherwise 200
      if (merror.empty?)
        render :json => {:groups =>  @group}, :status => 200
      else
        render :json => {:groups =>  @group, :memberError => merror}, :status => 206
      end
    else
      render :json => {:errors => @group.errors.full_messages}, :status => 400
    end
  end

  # view all the members in the given group by gid
  def viewmembers
    @group = Group.find(params[:view][:id])
    if current_user.member?(@group)
       render :json => {:groups =>  @group.users}, :status => 200
    else
       #render :json => {:errors => {"message" = "you not in group"}}, 
       render :status => 400
    end
  end

  # invite user to group, give email to identify user, and gid to identify group
  def invitetogroup
    @group = Group.find(params[:invite][:gid])
    @user = User.where("email = ?", params[:invite][:email])

    if current_user.member?(@group) && !@user.nil?
       @group.users << @user
       render :json => {:groups =>  @group.users}, :status => 200
    else
       #render :json => {:errors => {"message" = "you not in group or no user"}}, 
       render :status => 400
    end
  end


  def destroy
  end

  private
    # params to create group
    def group_params
      params.require(:group).permit(:name, :description).merge(creator: current_user.id)
    end

    def members_params
      params.require(:add).permit(:members => [])
    end

end
