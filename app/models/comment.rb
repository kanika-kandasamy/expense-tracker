class Comment < ApplicationRecord
  belongs_to :expense

  has_many :children, class_name: 'Comment', dependent: :destroy, foreign_key: :parent_id
  belongs_to :parent, class_name: 'Comment', optional: true

end
