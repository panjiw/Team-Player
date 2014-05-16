class TasksController < ApplicationController
  # Creates a new task where the creator is the signed in user
  # Accepts post request with format of:
  # Required:
  # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
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
                     finished: params[:task][:finished].to_bool)
    if @task.save
      order = 0
      params[:task][:members].each do |m|
        @task_actor = TaskActor.new(task_id: @task[:id],
                                    user_id: m[0],
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

  # Returns all the task of the signed in user
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
  def get_task_in_range
    render :json => {:errors => "Not implemented yet"}, :status => 400
  end
end