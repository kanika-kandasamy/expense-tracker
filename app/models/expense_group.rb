class ExpenseGroup < ApplicationRecord
  belongs_to :employee
  has_many :expenses, dependent: :destroy
end
