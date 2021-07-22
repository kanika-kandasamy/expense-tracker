class AddEmployeeToExpense < ActiveRecord::Migration[6.1]
  def change
    add_reference :expenses, :employee, foreign_key: true, index: true
  end
end
