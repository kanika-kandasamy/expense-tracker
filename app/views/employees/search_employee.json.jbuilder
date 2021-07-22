json.extract! @employee, :id, :name, :email, :gender, :department, :contact, :active_status
json.expense_groups(@employee.expense_groups.where(status: "submitted")) do |expense_group|
    json.id expense_group.id
    json.title expense_group.title
    json.status expense_group.status
    json.applied_amount expense_group.applied_amount
    json.approved_amount expense_group.approved_amount
    json.expenses(expense_group.expenses.where(status: "pending")) do |expense|
        json.id expense.id
        json.employee_id expense.employee_id
        json.expense_group_id expense.expense_group_id
        json.expense_type expense.expense_type
        json.invoice_number expense.invoice_number
        json.date expense.date
        json.description expense.description
        json.amount expense.amount
        json.attachment expense.attachment
        json.expense_system_validate expense.expense_system_validate
        json.status expense.status
        json.comments(expense.comments) do |comment|
            json.id comment.id
            json.parent_id comment.parent_id
            json.description comment.description
            json.created_by comment.created_by
        end
    end
end
    json.expenses(@employee.expenses.where(status: "pending")) do |expense|
        json.id expense.id
        json.employee_id expense.employee_id
        json.expense_group_id expense.expense_group_id
        json.expense_type expense.expense_type
        json.invoice_number expense.invoice_number
        json.date expense.date
        json.description expense.description
        json.amount expense.amount
        json.attachment expense.attachment
        json.expense_system_validate expense.expense_system_validate
        json.status expense.status
        json.comments(expense.comments) do |comment|
            json.id comment.id
            json.parent_id comment.parent_id
            json.description comment.description
            json.created_by comment.created_by
            json.expense_id comment.expense_id
        end
    end
    