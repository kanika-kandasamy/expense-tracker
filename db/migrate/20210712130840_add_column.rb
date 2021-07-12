class AddColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :status, :string, default: :null
    add_column :expense_groups, :status, :string, default: :null
  end
end
