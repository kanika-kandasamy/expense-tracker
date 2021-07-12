class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.belongs_to :expense_group, null: false, foreign_key: true
      t.integer :invoice_number
      t.date :date
      t.text :description
      t.integer :amount
      t.string :attachment
      t.boolean :expense_system_validate
      t.boolean :status

      t.timestamps
    end
  end
end
