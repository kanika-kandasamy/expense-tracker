class ExpenseGroupsController < ApplicationController
   
    # GET employees/1/expense_groups
    def index
        expense_groups = ExpenseGroup.find_by(employee_id: params[:employee_id])
        render json: expense_groups
    end


    # POST employees/1/expense_groups
    def create
        employee = Employee.find_by(id: params[:employee_id])
        if employee.active_status == true
            expense_group = employee.expense_groups.create(expense_group_params)
            expense_group.expenses.each do |expense|
            system_check(expense, employee, expense_group)   
            expense.employee_id = expense_group.employee_id
            expense.update(employee_id: expense.employee_id)
            expense.save
            end
        else
            render json: "Error, terminated employees cannot apply for reimbursement"
        end
    end


    def expense_group_status(expense_g)
        expense_group = ExpenseGroup.find_by(id: expense_g.id)
        employee = Employee.find_by(id: expense_group.employee_id)
        approved = []
        rejected = []
        expense_pending = expense_group.expenses.where(status: "pending")
        if expense_pending.count == 0 && !(expense_group.completed?) && expense_group.submitted?
            expense_group.applied_amount = 0
            expense_group.approved_amount = 0
            expense_group.expenses.each do |expense|
                if expense.approved?
                    expense_group.approved_amount += expense.amount
                    expense_group.applied_amount += expense.amount
                    approved << expense.description
                elsif expense.rejected?
                    rejected << expense.description
                    expense_group.applied_amount += expense.amount
                elsif expense.rejected_by_system?
                    rejected << expense.description
                    expense_group.applied_amount += expense.amount
                end
            end
            expense_group.save
            ExpenseGroupMailer.with(user: employee, title: expense_group.title, applied_amount: expense_group.applied_amount, approved_amount: expense_group.approved_amount, approved: approved, rejected: rejected).approve_message.deliver_now
            expense_group.update(status: "completed" ) 
        end
    end

    # DELETE employees1/expense_groups/1
    def destroy
        employee = Employee.find_by(id: params[:employee_id])
        expense_group = employee.expense_groups.find_by(id: params[:id])
        if expense_group.destroy
            render json: "Successfully deleted!"
        else
            render json: "Error"
        end
    end 

    # PATCH employees/4/expense_groups/2/update_status
    def update_status
        employee = Employee.find_by(id: params[:employee_id])
        expense_group = employee.expense_groups.find_by(id: params[:expense_group_id])
        data = params.permit(%i[status])
        if expense_group.pending?
            expense_group.update(data)
        else
            render json: "Expense group already submitted"
        end
    end

    # GET employees/1/expense_groups/1/show_all_expenses
    def show_all_expenses
        employee = Employee.find_by(id: params[:employee_id])
        expense_group = employee.expense_groups.find_by(id: params[:expense_group_id])
        expenses = expense_group.expenses.all
        render json: expenses
    end
    
    private
    def expense_group_params
        params.require(:expense_group).permit(:title, :expenses_attributes => [:invoice_number, :date, :description, :expense_type, :amount, :attachment])
    end
end
