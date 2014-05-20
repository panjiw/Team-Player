class GroupsController < ApplicationController
  before_action :signed_in_user

 
  # create a new group and add current_user to group + creator
  # require user to be logined
  # Accepts post request with format of:
  # Required:
  # group[name]: name
  # group[description]: description
  #
  # See group model in the front end for more info
  #
  # Returns
  # {
  # "id":group id,
  # "name":name of group,
  # "description":description of group,
  # "creator":id of person created the group (logined user),
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "self":true or false indicating self group or not, false when call this method
  # "users":[{"id":1, "username":"User1"....user info}]
  # at the end it returns an array of users who are in this new group
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
  # require user to be logined
  #
  # Returns
  # {
  # "id":group id,
  # "name":name of group,
  # "description":description of group,
  # "creator":id of person created the group (logined user),
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "self":true or false indicating self group or not, false when call this method
  # "users":[{"id":1, "username":"User1"....user info}]
  # at the end it return a list of useres who are in that group
  def viewmembers
    @group = Group.find(params[:view][:id])
    if current_user.member?(@group)
       render :json => {:groups =>  @group.users}, :status => 200
    else
       #render :json => {:errors => {"message" = "you not in group"}}, 
       render :status => 400
    end
  end

  # edit group, given the following params, this will change the 
  # require user to be logined, and creator of the group
  # editgroup[id]: group to be edited
  # editgroup[name]: new name or same name for this group
  # editgroup[description]: new description














  # invite user to group, give email to identify user, and gid to identify group
  # require user to be logined
  #    given user need to be in the group inviting to
  # Accepts post request with format of:
  # Required:
  # invite[email]: email (case insensitive)
  # invite[gid]: group id to invite user to
  #
  #
  # Returns, array of user who are in the group
  # [{"id": id of user
  #   "username":user name 
  #   "firstname": first name
  #   "lastname": last name
  #   "email": email of user
  #}  .. user 2 user 3... etc for all members of the group]
  def invitetogroup
    group = Group.find(params[:invite][:gid])
    user = User.where("email = ?", params[:invite][:email].downcase)
    error = []
    flag = false
    if !User.member?(current_user, group)
      flag = true
      error << "You not in group, no permission"
    end
    if user.empty?
      flag = true
      error << "User not found"
    end
    if group.self
      flag = true
      error << "Can not add to self group"
    end
    if User.member?(user, group)
      flag = true
      error << "User already in group"
    end

    if flag
      render :json => {:errors => error}, :status => 400
    else
      group.users << user
      render :json => group.users.to_json(:except => [:created_at, :updated_at, 
      :password_digest, :remember_token]), :status => 200
    end
  end

  # do nothing atm
  def destroy
  end

  private
    # params to create group, append current logined user id as creator
    # and append self group tag to false
    def group_params
      params.require(:group).permit(:name, :description).merge(creator: current_user.id, self: false)
    end

    # not used?    
    def members_params
      params.require(:add).permit(:members => [])
    end

end

