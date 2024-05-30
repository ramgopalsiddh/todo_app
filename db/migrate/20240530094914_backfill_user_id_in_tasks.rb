class BackfillUserIdInTasks < ActiveRecord::Migration[7.1]
  def change
    Task.update_all(user_id: 1)

    change_column_null :tasks, :user_id, false
  end
end
