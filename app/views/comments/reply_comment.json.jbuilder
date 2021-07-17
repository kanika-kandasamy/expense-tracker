json.extract! @comment, :id, :parent_id, :description
json.id @comment.id
json.parent_id @comment.parent_id
json.description @comment.description 
json.created_by @comment.created_by
json.expense_id @comment.expense_id
