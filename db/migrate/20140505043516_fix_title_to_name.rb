class FixTitleToName < ActiveRecord::Migration
  def change
    rename_column :groups, :title, :name
  end
end
