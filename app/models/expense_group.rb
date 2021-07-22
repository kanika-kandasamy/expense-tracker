class ExpenseGroup < ApplicationRecord
  belongs_to :employee
  has_many :expenses, dependent: :destroy
  accepts_nested_attributes_for :expenses

  validates_associated :expenses, allow_destroy: true

  enum status: [:pending, :submitted, :completed]
end
