class TaskGeneratorsController < ApplicationController

  def new
    if !view_context.signed_in?
      redirect_to '/'
    end
    if params[:task][:repeat_days] == "" && !params[:task][:cycle].to_bool
      render :json => {:errors => "No need for generator"}, :status => 400
      return
    end
    @task_generator = TaskGenerator.new(group_id: params[:task][:group_id],
                                        user_id: view_context.current_user[:id],
                                        title: params[:task][:title],
                                        description: params[:task][:description],
                                        cycle: params[:task][:cycle].to_bool,
                                        finished: params[:task][:finished].to_bool)
    if params[:task][:repeat_days] == ""
      @task_generator[:repeat_days] = nil
    else
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

  def create_new_task
    if !view_context.signed_in?
      redirect_to '/'
    end
    if @task_generator.nil?
      @task_generator = TaskGenerator.find_by_current_task_id(params[:task][:id])
    end
    @next_task = Task.new(group_id: @task_generator[:group_id],
                          user_id: @task_generator[:user_id],
                          title: @task_generator[:title],
                          description: @task_generator[:description],
                          finished: false)

    if @next_task.save
      if @task_generator[:current_task_id]
        # get the old task
        @finished_task = Task.find(@task_generator[:current_task_id]) # not actually marking it finished
      else
        @finished_task = nil
      end

      # Repeat
      if @task_generator[:repeat_days]
        if @finished_task
          today = @finished_task[:due_date]
        else
          today = Date.today
        end
        days = (today.cwday + 1) % 8
        if days == 0
          days = 1
        end
        while days != today.cwday
          if @task_generator[:repeat_days][days]
            break
          end
          days = (days + 1) % 8
          if days == 0
            days = 1
          end
        end
        if days <= today.cwday
          days += 7
        end
        days = days - today.cwday
        next_due_date = today + days
        @next_task.update_attributes(:due_date => next_due_date)
      end

      # Cycle
      if @task_generator.cycle && @finished_task
        # get the old task's actor
        current_actor = @finished_task.task_actors.find_by_order(0)
        # get info about the actors for the next task
        actors = @task_generator.task_generator_actors
        # get that user's order in the generator
        current_actor = actors.find_by_user_id(current_actor[:user_id])
        current_order = current_actor[:order]
        # total number of actors
        total_actors = actors.count
        # the next actor's order in the generator
        orders = (current_order + 1) % total_actors
        # in task it will be listed as 0
        next_order = 0
        while next_order < total_actors
          @next_task_actor = TaskActor.new(task_id: @next_task[:id],
                                           user_id: actors.find_by_order(orders)[:user_id],
                                           order: next_order)
          if !@next_task_actor.save
            # this should never happen
            @next_task.destroy
            render :json => {:errors => @next_task_actor.errors.full_messages}, :status => 400
          end
          orders = (orders + 1) % total_actors
          next_order += 1
        end
      else
        # no cycle or first one
        @task_generator.task_generator_actors.each do |a|
          @next_task_actor = TaskActor.new(task_id: @next_task[:id],
                                           user_id: a[:user_id],
                                           order: a[:order])
          if !@next_task_actor.save
            # this should never happen
            @next_task.destroy
            render :json => {:errors => @next_task_actor.errors.full_messages}, :status => 400
            return
          end
        end
      end
      @task_generator.update_attributes(:current_task_id => @next_task[:id])
      generator_and_task = {}
      generator = {}
      generator[:details] = @task_generator
      generator[:members] = {}
      @task_generator.task_generator_actors.each do |a|
        generator[:members][a[:user_id]] = a[:order]
      end
      task = {}
      task[:details] = @next_task
      task[:members] = {}
      @next_task.task_actors.each do |a|
        task[:members][a[:user_id]] = a[:order]
      end
      generator_and_task[:generator] = generator
      generator_and_task[:task] = task
      render :json => generator_and_task.to_json, :status => 200
    else
      render :json => {:errors => @next_task.errors.full_messages}, :status => 400
    end
  end
end