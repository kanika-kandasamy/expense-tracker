class RenameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :expense_groups, :total_amount, :applied_amount
    add_column :expense_groups, :approved_amount, :integer, default: 0
  end
end
