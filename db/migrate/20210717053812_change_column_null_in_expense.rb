class ChangeColumnNullInExpense < ActiveRecord::Migration[6.1]
  def change
    change_column_null :expenses, :expense_group_id, true
  end
end
