class AddColumnToExpenseGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :expense_groups, :status, :string, default: "Pending"
  end
end
