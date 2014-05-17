class GroupsController < ApplicationController
  before_action :signed_in_user

  # create a new group and add current_user to group + creator
  def create
    group = current_user.groups.build(group_params)
    if group.save
      # link membership association between new group and creator
      group.users << current_user

      # for each members in paramter, add to group
      merror = ""
      if(params.has_key?(:add))
        members = params[:add][:members]
        members.each do |id|
          if(User.exists?(id) && id != current_user.id.to_s)
	    group.users << User.find(id)
      puts "id " + id + "exists!"
          else
	    merror << " " + id << " "
          end
        end
      end

      # if one of the user is not found shows who (merror) and status 206 otherwise 200
      if (merror.empty?)
        render :json => group.to_json(:include => [:users => {:except => [:created_at, :updated_at, 
			:password_digest, :remember_token]}]), :status => 200
      else
        render :json => group.to_json(:include => [:users => {:except => [:created_at, :updated_at, 
			:password_digest, :remember_token]}], :memberError => merror), :status => 206
      end
    else
      render :json => {:errors => group.errors.full_messages}, :status => 400
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
    group = Group.find(params[:invite][:gid])
    user = User.where("email = ?", params[:invite][:email].downcase)
    error = []
    flag = false
    if !User.member?(current_user, group)
      flag = true
      error << "You not in group, no permission"
      # render :json => {:errors => {"message" => "you not in group"}}, :status => 400
    end
    if user.empty?
      flag = true
      error << "User not found"
      #render :json => {:errors => {"message" => "user not found"}}, :status => 400
    end
    if group.self
      flag = true
      error << "Can not add to self group"
      #render :json => {:errors => {"message" => "Can not add to self group"}}, :status => 400
    end
    if User.member?(user, group)
      flag = true
      error << "User already in group"
      #render :json => {:errors => {"message" => "User already in group"}}, :status => 400
    end

    if flag
      render :json => {:errors => error}, :status => 400
    else
      group.users << user
      render :json => group.users, :status => 200
    end
  end


  def destroy
  end

  private
    # params to create group
    def group_params
      params.require(:group).permit(:name, :description).merge(creator: current_user.id, self: false)
    end

    def members_params
      params.require(:add).permit(:members => [])
    end

end
