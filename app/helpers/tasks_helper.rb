module TasksHelper
   def remove_user_tasks(group)
    current_user.tasks.where(group_id: group.id).each do |t|
      if (t.user_id = current_user.id)
        t.users.delete(current_user)
      end
    end
  end
end
