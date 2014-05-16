class TasksController < ApplicationController
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

  def get_task_in_range
    render :json => {:errors => "Not implemented yet"}, :status => 400
  end
end