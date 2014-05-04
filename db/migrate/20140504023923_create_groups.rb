class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.string :description
      t.integer :creator

      t.timestamps
    end
  end
end
