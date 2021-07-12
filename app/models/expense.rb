class Expense < ApplicationRecord
  belongs_to :expense_group
  has_many :comments, dependent: :destroy
end
