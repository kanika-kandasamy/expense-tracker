json.extract! @employee, :id, :name, :email, :gender, :department, :contact, :active_status
json.expense_groups(@employee.expense_groups) do |expense_group|
    json.id expense_group.id
    json.title expense_group.title
    json.status expense_group.status
    json.applied_amount expense_group.applied_amount
    json.approved_amount expense_group.approved_amount
    json.expenses(expense_group.expenses) do |expense|
        json.id expense.id
        json.invoice_number expense.invoice_number
        json.date expense.date
        json.description expense.description
        json.amount expense.amount
        json.attachment expense.attachment
        json.status expense.status
        json.comments(expense.comments) do |comment|
            json.id comment.id
            json.description comment.description
            json.reply comment.reply
        end
    end
end

    