class ChangeColumns < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:expenses, :status, "Pending")
    remove_column(:expense_groups, :status)
    remove_column(:comments, :reply)
    add_column(:comments, :parent_id, :integer)
  end
end
