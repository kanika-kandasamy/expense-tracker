class Expense < ApplicationRecord
  belongs_to :expense_group, optional: true
  belongs_to :employee
  has_many :comments, dependent: :destroy

  enum status: [:pending, :approved, :rejected, :rejected_by_system]
  enum expense_type: [:food, :travel, :vaccine, :accommodation, :others]
end
