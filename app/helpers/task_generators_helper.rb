module TaskGeneratorsHelper
  def new_task(task_generator)
    next_task = Task.new(group_id: task_generator[:group_id],
                          user_id: task_generator[:user_id],
                          title: task_generator[:title],
                          description: task_generator[:description],
                          finished: false)

    if next_task.save
      if task_generator[:current_task_id]
        # get the old task
        finished_task = Task.find(task_generator[:current_task_id]) # not actually marking it finished
      else
        finished_task = nil
      end

      # Repeat
      if task_generator[:repeat_days]
        if finished_task
          today = finished_task[:due_date]
          days = (today.cwday + 1) % 8
          if days == 0
            days = 1
          end
          while days != today.cwday
            if task_generator[:repeat_days][days]
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
        else
          next_due_date = task_generator[:due_date]
        end
        next_task.update_attributes(:due_date => next_due_date)
      end

      # Cycle
      if task_generator.cycle && finished_task
        # get the old task's actor
        current_actor = finished_task.task_actors.find_by_order(0)
        # get info about the actors for the next task
        actors = task_generator.task_generator_actors
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
          next_task_actor = TaskActor.new(task_id: next_task[:id],
                                           user_id: actors.find_by_order(orders)[:user_id],
                                           order: next_order)
          if !next_task_actor.save
            next_task.errors[:base] << "Unable to add members"
            return next_task
          end
          orders = (orders + 1) % total_actors
          next_order += 1
        end
      else
        # no cycle or first one
        task_generator_holder = TaskGenerator.find(task_generator[:id])
        task_generator_holder.task_generator_actors.each do |a|
          next_task_actor = TaskActor.new(task_id: next_task[:id],
                                           user_id: a[:user_id],
                                           order: a[:order])
          if !next_task_actor.save
            next_task.errors[:base] << "Unable to add members"
            return next_task
          end
        end
      end
      task_generator.update(current_task_id: next_task[:id])
    end
    next_task
  end
end
