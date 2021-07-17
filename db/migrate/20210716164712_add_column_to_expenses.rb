class AddColumnToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column(:expenses, :type, :integer)
  end
end
