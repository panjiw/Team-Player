class TaskGeneratorsController < ApplicationController
  include TaskGeneratorsHelper
  # Creates a new task generator and a single task based on that
  # generator where the signed in user is the creator
  # Required:
  # task[group_id]: groupID
  # task[title]: title
  # task[total_due]: total
  # task[due_date]: date
  # task[members]: {user_id, ..., user_id} (place in array is order)
  # task[repeat_days]: [boolean, ..., boolean]  1 for each day of the week
  # task[cycle]: boolean
  # Optional:
  # task[description]: description
  #
  # See tasks model in the front end for more info
  #
  # Returns the info of the generator and the new task
  # {"generator":{generator info (see get_all for format)},
  #  "task":{task info (see task_controller for format)}}
  def new
    if !view_context.signed_in?
      redirect_to '/'
    end
    if params[:task][:repeat_days] == "" && !params[:task][:cycle].nil? && !params[:task][:cycle].to_bool
      render :json => {:errors => "No need for generator"}, :status => 400
      return
    end
    @task_generator = TaskGenerator.new(group_id: params[:task][:group_id],
                                        user_id: view_context.current_user[:id],
                                        title: params[:task][:title],
                                        description: params[:task][:description],
                                        cycle: params[:task][:cycle].to_bool,
                                        due_date: params[:task][:due_date],
                                        finished: false)
    if params[:task][:repeat_days] == ""
      @task_generator[:repeat_days] = nil
    else
      if params[:task][:repeat_days].length != 7
        render :json => {:errors => "Invalid repeat pattern"}, :status => 400
        return
      end
      @task_generator[:repeat_days] = {}
      day = 1
      params[:task][:repeat_days].each do |d|
        if d.to_bool
          @task_generator[:repeat_days][day] = true
        else
          @task_generator[:repeat_days][day] = false
        end
        day += 1
      end
    end
    if @task_generator.save
      order = 0
      params[:task][:members].each do |m|
        @task_generator_actor = TaskGeneratorActor.new(task_generator_id: @task_generator[:id],
                                                       user_id: m[0],
                                                       order: order)
        if !@task_generator_actor.save
          @task_generator.destroy
          render :json => {:errors => @task_generator_actor.errors.full_messages}, :status => 400
          return
        end
        order = order + 1
      end
      create_new_task
    else
      render :json => {:errors => @task_generator.errors.full_messages}, :status => 400
    end
  end

  # Creates a new task based on the generator of the given task
  # or the task generator instance set
  # If the former the task must be the most recent task created by
  # the generator
  # Returns the info of the generator and the new task
  # {"generator":{generator info (see get_all for format)},
  #  "task":{task info (see task_controller for format)}}
  def create_new_task
    if !view_context.signed_in?
      redirect_to '/'
    end
    if @task_generator.nil?
      @task_generator = TaskGenerator.find_by_current_task_id(params[:task][:id])
    end
    if @task_generator.nil?
      render :json => {:errors => "Invalid task"}, :status => 400
    end
    if @task_generator[:finished]
      render :json => {:errors => "The task generator is dead"}, :status => 400
    end
    next_task = new_task @task_generator
    if next_task.errors.empty?
      generator_and_task = {}
      generator = {}
      generator[:details] = @task_generator
      generator[:members] = {}
      task_generator_holder = TaskGenerator.find(@task_generator[:id])
      task_generator_holder.task_generator_actors.each do |a|
        generator[:members][a[:user_id]] = a[:order]
      end
      task = {}
      task[:details] = next_task
      task[:members] = {}
      task_holder = Task.find(next_task[:id])
      task_holder.task_actors.each do |a|
        task[:members][a[:user_id]] = a[:order]
      end
      generator_and_task[:generator] = generator
      generator_and_task[:task] = task
      render :json => generator_and_task.to_json, :status => 200
    else
      render :json => {:errors => next_task.errors.full_messages}, :status => 400
    end
  end

  # Returns all the task geerators of the signed in user
  # {number starting from 0:{"details":{
  # "id":task id,
  # "group_id":group id of the task,
  # "user_id":1,
  # "title":task title,
  # "description": task_description,
  # "finished_date":finished date,
  # "finished":finished,
  # "repeat_days":{"1":bool,...,"7":bool},
  # "cycle":bool,
  # "created_at":date and time created,
  # "updated_at":date and time updated,
  # "current_task_id":most current task created},
  # "members":{user_id:order, ..., user_id:order}}, ...}
  def get_all
    if view_context.signed_in?
      task_generators = {}
      count = 0
      current_user.groups.each do |g|
        g.task_generators.each do |t|
          task_generator = {}
          task_generator[:details] = t
          task_generator[:members] = {}
          t.task_generator_actors.each do |a|
            task_generator[:members][a[:user_id]] = a[:order]
          end
          task_generators[count] = task_generator
          count += 1
        end
      end
      render :json => task_generators.to_json, :status => 200
    else
      redirect_to '/'
    end
  end

  def mark_finished
    if view_context.signed_in?
      task_generator = TaskGenerator.find(params[:task][:id])
      if task_generator.nil?
        render :json => {:errors => "Invalid task generator"}, :status => 400
      else
        task_actor = task_generator.task_generator_actors.find_by_user_id(current_user[:id])
        if task_actor.nil?
          render :json => {:errors => "Unauthorized action"}, :status => 400
        else
          task_generator.update(finished: true, finished_date: Date.today)
          result = {}
          result[:details] = task_generator
          result[:members] = {}
          task_generator.task_generator_actors.each do |a|
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
      if params[:task][:repeat_days] == "" && !params[:task][:cycle].nil? && !params[:task][:cycle].to_bool
        render :json => {:errors => "No need for generator"}, :status => 400
        return
      end
      @task_generator = TaskGenerator.find(params[:task][:id])
      if !@task_generator.task_generator_actors.find_by_user_id(view_context.current_user[:id]) && @task_generator.user != view_context.current_user
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        @task_generator.group_id = params[:task][:group_id]
        @task_generator.user_id = view_context.current_user[:id]
        @task_generator.title = params[:task][:title]
        @task_generator.description = params[:task][:description]
        @task_generator.cycle = params[:task][:cycle].to_bool
        @task_generator.due_date = params[:task][:due_date]
        @task_generator.finished = params[:task][:finished]
        if params[:task][:repeat_days] == ""
          @task_generator[:repeat_days] = nil
        else
          if params[:task][:repeat_days].length != 7
            render :json => {:errors => "Invalid repeat pattern"}, :status => 400
            return
          end
          @task_generator[:repeat_days] = {}
          day = 1
          params[:task][:repeat_days].each do |d|
            if d.to_bool
              @task_generator[:repeat_days][day] = true
            else
              @task_generator[:repeat_days][day] = false
            end
            day += 1
          end
        end
        if @task_generator.save
          @task_generator.task_generator_actors.delete_all
          order = 0
          params[:task][:members].each do |m|
            @task_generator_actor = TaskGeneratorActor.new(task_generator_id: @task_generator[:id],
                                                           user_id: m[0],
                                                           order: order)
            if !@task_generator_actor.save
              @task_generator.destroy
              render :json => {:errors => @task_generator_actor.errors.full_messages}, :status => 400
              return
            end
            order = order + 1
          end
          old_task = Task.find(@task_generator[:current_task_id])
          old_task.destroy
          @task_generator.update(:current_task_id => nil)
          create_new_task
        else
          render :json => {:errors => @task_generator.errors.full_messages}, :status => 400
        end
      end
    else
      redirect_to '/'
    end
  end

  def delete
    if view_context.signed_in?
      @task_generator = TaskGenerator.find(params[:task][:id])
      if !@task_generator.task_generator_actors.find_by_user_id(view_context.current_user[:id]) && @task_generator.user != view_context.current_user
        render :json => {:errors => "Unauthorized action"}, :status => 400
      else
        @task = Task.find(@task_generator[:current_task_id])
        @task.destroy
        @task_generator.destroy
        render :json => {:status => "success"}, :status => 200
      end
    else
      redirect_to '/'
    end
  end
end