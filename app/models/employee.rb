class Employee < ApplicationRecord
    has_many :expense_groups, dependent: :destroy
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
    validates :contact, presence: true, uniqueness: true
end
