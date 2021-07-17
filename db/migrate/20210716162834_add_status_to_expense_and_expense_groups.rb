class AddStatusToExpenseAndExpenseGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :status, :integer, default: 0
    add_column :expense_groups, :status, :integer, default: 0
  end
end
