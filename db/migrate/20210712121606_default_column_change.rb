class DefaultColumnChange < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:expenses, :status, :null)
    change_column_default(:employees, :admin, false)
    change_column_default(:employees, :active_status, true)
    change_column_default(:expenses, :expense_system_validate, false)
    change_column_default(:expense_groups, :total_amount, 0)
  end
end
