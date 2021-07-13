class ExpenseGroupsController < ApplicationController
    ALLOWED_DATA = %[title applied_amount approved_amount status].freeze
   

    def index
        expense_groups = ExpenseGroup.group(:employee_id)
        render json: expense_groups
    end

    def create_expense_group
        employee = Employee.find_by(id: params[:emp_id])
        if employee.active_status == true
            data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
            expense_group = employee.expense_groups.new(data)
            if expense_group.save
                render json: expense_group
            else
                render json: "error" 
            end
        end
    end

    def expense_group_status
        user = Employee.find_by(id: params[:u_id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        employee = Employee.find_by(id: params[:emp_id])
        if user.id == employee.id
            render json: "Error : Users cannot approve their own requests" 
        else
            expense_group = employee.expense_groups.find_by(id: params[:expg_id])
            data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
            expense_group.update(data)
            approved = []
            rejected = []
            if expense_group.status == "Completed"
                expense_group.applied_amount = 0
                expense_group.approved_amount = 0
                expense_group.expenses.each do |expense|
                    if expense.status== "Approved"
                        expense_group.approved_amount += expense.amount
                        expense_group.applied_amount += expense.amount
                        approved << expense.description
                    elsif expense.status == "Rejected"
                        rejected << expense.description
                        expense_group.applied_amount += expense.amount
                    end
                end
                expense_group.save
                if expense_group.approved_amount == 0
                    ExpenseGroupMailer.with(user: employee, title: expense_group.title, applied_amount: expense_group.applied_amount).reject_message.deliver_now
                else
                    ExpenseGroupMailer.with(user: employee, title: expense_group.title, applied_amount: expense_group.applied_amount, approved_amount: expense_group.approved_amount, approved: approved, rejected: rejected).approve_message.deliver_now
                end   
            end
        end
    end

    def delete_expense_group
        employee = Employee.find_by(id: params[:emp_id])
        expense_group = employee.expense_groups.find_by(id: params[:expg_id])
        if expense_group.destroy
            render json: "Successfully deleted!"
        else
            render json: "Error"
        end
    end 
end
