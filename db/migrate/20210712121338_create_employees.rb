class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :email
      t.string :name
      t.string :department
      t.string :gender
      t.string :contact
      t.boolean :admin
      t.boolean :active_status

      t.timestamps
    end
  end
end
