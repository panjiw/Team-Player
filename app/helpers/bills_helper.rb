module BillsHelper
   def remove_user(group)
    current_user.bills.where(group_id: group.id).each do |b|
      if (b.user_id = current_user.id && b.group_id = group.id)
        # user is creator of the bill, destroy the bills 
        b.destroy
      else
        amt = b.bill_actors.where(user_id: current_user.id).first.due
        b.total_due = b.total_due - amt
        b.users.delete(current_user)
      end
    end
  end
end
