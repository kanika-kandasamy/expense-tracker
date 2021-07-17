class RemoveStatusFromExpenseAndExpenseGroups < ActiveRecord::Migration[6.1]
  def change
    remove_column :expenses, :status
    remove_column :expense_groups, :status
  end
end
