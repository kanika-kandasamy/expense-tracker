class CommentsController < ApplicationController
    ALLOWED_DATA = %[description reply].freeze
    def create_comment
        user = Employee.find_by(id: params[:id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        employee = Employee.find_by(id: params[:emp_id])
        if user.id == employee.id
            render json: "Error" 
        else
            expense_group = employee.expense_groups.find_by(id: params[:expg_id])
            expense = expense_group.expenses.find_by(id: params[:exp_id])
            data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
            comment = expense.comments.new(data)
            if comment.save
                render json: comment
            else
                render json: "error" 
            end
        end
    end


    def show_comments
        expense = Expense.find_by(id: params[:id])
        render json: expense.comments
    end


    def reply_comment
        comment = Comment.find_by(id: params[:id])
        data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
        if comment.update(data)
            render json: comment
        end
    end

    def delete_comment
        user = Employee.find_by(id: params[:id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        employee = Employee.find_by(id: params[:emp_id])
        if user.id == employee.id
            render json: "Error" 
        else
            expense_group = employee.expense_groups.find_by(id: params[:expg_id])
            expense = expense_group.expenses.find_by(id: params[:exp_id])
            comment = expense.comments.find_by(id: params[:c_id])
            if comment.destroy
                render json: "Comment successfully deleted"
            else
                render json: "error" 
            end
        end
    end

    def modify_reply
        comment = Comment.find_by(id: params[:id])
        data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
        if comment.update(data)
            render json: "Reply modified"
        end
    end
end
