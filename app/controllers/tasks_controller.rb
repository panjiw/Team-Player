class TasksController < ApplicationController

  # Creates a new task where the creator is the signed in user
  # Accepts post request with format of:
  # Required:
  # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
  # task[finished]: false
  # task[members]: {user_id, ..., user_id} (place in array is order)
  # Optional:
  # task[description]: description
  # task[due_date]: dateDue
  #
  # See tasks model in the front end for more info
  #
  # Returns
  # {"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}}
  def new
    if !view_context.signed_in?
      redirect_to '/'
    end
    @task = Task.new(group_id: params[:task][:group_id],
                     user_id: view_context.current_user[:id],
                     title: params[:task][:title],
                     description: params[:task][:description],
                     due_date: params[:task][:due_date],
                     finished: false)
    if @task.save
      order = 0
      params[:task][:members].each do |m|
        @task_actor = TaskActor.new(task_id: @task[:id],
                                    user_id: m,
                                    order: order)
        if !@task_actor.save
          @task.destroy
          render :json => {:errors => @task_actor.errors.full_messages}, :status => 400
          return
        end
        order = order + 1
      end
      task = {}
      task[:details] = @task
      task[:members] = {}
      @task.task_actors.each do |a|
        task[:members][a[:user_id]] = a[:order]
      end
      render :json => task.to_json, :status => 200
    else
      render :json => {:errors => @task.errors.full_messages}, :status => 400
    end
  end

  # Returns all the tasks of the signed in user
  # {number starting from 0:{"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}}, ...}
  def get_all
    if view_context.signed_in?
      tasks = {}
      count = 0
      current_user.tasks.each do |t|
        task = {}
        task[:details] = t
        task[:members] = {}
        t.task_actors.each do |a|
          task[:members][a[:user_id]] = a[:order]
        end
        tasks[count] = task
        count += 1
      end
      render :json => tasks.to_json, :status => 200
    else
      redirect_to '/'
    end
  end

  # Returns all the tasks of the signed in user within the
  # given (through get) range: date[start] <= task[:created_at] <= date[end]
  # {number starting from 0:{"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "due_date":due date,
  # "finished_date":finished date,
  # "finished":finished,
  # "created_at":date and time created,
  # "updated_at":date and time updated},
  # "members":{user_id:order, ..., user_id:order}}, ...}
  def get_task_in_range
    render :json => {:errors => "Not implemented yet"}, :status => 400
  end

  # Mark the task with the given id as finished
  # Returns the info of the task
  def mark_finished
    if view_context.signed_in?
      task = Task.find(params[:task][:id])
      if task.nil?
        render :json => {:errors => "Invalid task"}, :status => 400
      else
        task_actor = task.task_actors.find_by_user_id(current_user[:id])
        if task_actor.nil?
          render :json => {:errors => "Unauthorized action"}, :status => 400
        else
          task.update(finished: true, finished_date: Date.today)
          result = {}
          result[:details] = task
          result[:members] = {}
          task.task_actors.each do |a|
            result[:members][a[:user_id]] = a[:order]
          end
          render :json => result.to_json, :status => 200
        end
      end
    else
      redirect_to '/'
    end
  end
  def edit
    if view_context.signed_in?
      @task = Task.find(params[:task][:id])
      if !@task.task_actors.find_by_user_id(view_context.current_user[:id]) || @task.user != view_context.current_user[:id]
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        if @task.update(group_id: params[:task][:group_id],
                        user_id: view_context.current_user[:id],
                        title: params[:task][:title],
                        description: params[:task][:description],
                        due_date: params[:task][:due_date],
                        finished: params[:task][:finished])
          @task.users.delete_all
          order = 0
          params[:task][:members].each do |m|
            @task_actor = TaskActor.new(task_id: @task[:id],
                                        user_id: m,
                                        order: order)
            if !@task_actor.save
              @task.destroy
              render :json => {:errors => @task_actor.errors.full_messages}, :status => 400
              return
            end
            order = order + 1
          end
          task = {}
          task[:details] = @task
          task[:members] = {}
          @task.task_actors.each do |a|
            task[:members][a[:user_id]] = a[:order]
          end
          render :json => task.to_json, :status => 200
        else
          render :json => {:errors => @task.errors.full_messages}, :status => 400
        end
      end
    else
      redirect_to '/'
    end
  end

  def delete
    if view_context.signed_in?
      @task = Task.find(params[:task][:id])
      if !@task.users.find_by_user_id(view_context.current_user[:id])
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        @task.destroy
        render :json => {:status => "success"}, :status => 200
      end
    else
      redirect_to '/'
    end
  end
end