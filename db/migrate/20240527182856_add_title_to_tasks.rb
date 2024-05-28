class AddTitleToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :title, :string, limit: 100
  end
end
