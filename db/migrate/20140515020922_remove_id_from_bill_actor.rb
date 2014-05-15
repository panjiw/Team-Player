class RemoveIdFromBillActor < ActiveRecord::Migration
  def change
    remove_column :bill_actors, :id
  end
end
