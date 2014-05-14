class AddSelfToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :self, :boolean
    Group.reset_column_information
    Group.update_all(self: false)
  end
end
