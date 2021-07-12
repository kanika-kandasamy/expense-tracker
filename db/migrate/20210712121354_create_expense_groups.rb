class CreateExpenseGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_groups do |t|
      t.belongs_to :employee, null: false, foreign_key: true
      t.string :title
      t.integer :total_amount
      t.boolean :status

      t.timestamps
    end
  end
end
