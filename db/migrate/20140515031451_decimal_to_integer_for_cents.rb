class DecimalToIntegerForCents < ActiveRecord::Migration
  def change
    change_column :bill_actors, :due, :integer
    change_column :bills, :total_due, :integer
  end
end
