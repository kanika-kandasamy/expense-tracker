class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :expense, null: false, foreign_key: true
      t.text :description
      t.text :reply

      t.timestamps
    end
  end
end
