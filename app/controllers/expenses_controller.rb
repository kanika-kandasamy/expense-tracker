require 'net/http'
require 'uri'
require 'json'

class ExpensesController < ExpenseGroupsController

    before_action :set_user_and_check_authorization, only: [:update_expense_status, :update_status]
    before_action :set_details, only: [:index, :create, :destroy, :destroy_expense, :show_expense]


    # GET employees/1/expenses
    def index
        expenses = @employee.expenses.all
        render json: expenses
    end

    # POST employees/1/expenses
    def create
        if @employee.active_status == true
            if params[:expense_group_id] == nil
                expense = @employee.expenses.create!(params.permit(%i[invoice_number date description expense_type amount attachment]))
                if expense.save
                    system_check(expense, @employee, nil)
                    render json: expense
                else
                    render json: { error: {message: "Something went wrong" } }, status: :internal_server_error 
                end
            else
                expense_group = ExpenseGroup.find_by(id: params[:expense_group_id])
                if !(expense_group.nil?)
                    if !(expense_group.pending?)
                        render json: {error: { message: "Expense report already submitted. You can't add expense" } }, status: :bad_request 
                    else
                        expense = expense_group.expenses.create(params.permit(%i[invoice_number date description expense_type amount attachment]))
                        expense.employee_id = expense_group.employee_id
                        expense.update(employee_id: expense.employee_id)
                        if expense.save
                            system_check(expense, @employee, nil)
                            render json: expense
                        else
                            render json: { error: {message: "Something went wrong" } }, status: :internal_server_error 
                        end
                    end
                else
                    render json: { error: { message: "No such expense group" } }, status: :bad_request 
                end
            end
        else
            render json: { error: { message:  "terminated employees cannot apply for reimbursement" } }, status: :bad_request 
        end
    end

    # GET employees/1/expenses/1
    def show
        expense = @employee.expenses.find_by(id: params[:id])
        render json: expense
    end


    # DELETE employees/1/expenses/1
    def destroy
        expense = @employee.expenses.find_by(id: params[:id])
        expense_group = ExpenseGroup.find_by(id: expense.expense_group_id) if expense.expense_group_id != "null"
        if (!(expense_group.nil?) && expense_group.pending?)
            if expense.destroy
                render json: { message: "Expense deleted!"}, status: :ok
            else
                render json: { error: {message: "Something went wrong" } }, status: :internal_server_error 
            end
        else
            render json: { error: { message: "Expense already submitted. You cant remove the expense now."} }, status: :bad_request
        end
    end


    #PATCH expenses/1/update_status
    def update_status
        expense = Expense.find_by(id: params[:expense_id])
        employee = Employee.find_by(id: expense.employee_id)
        if @user.id == employee.id
            render json: { error: { message: "Users cannot approve their own requests"} }, status: :forbidden
        else
            data = params.permit(%i[status])
            expense_group = ExpenseGroup.find_by(id: expense.expense_group_id) if expense.expense_group_id != "null"
            if expense_group.nil?
                if expense.expense_system_validate == true && expense.pending? 
                    expense.update(data)
                    render json: { message: "status updated!"}, status: :ok
                    if expense.approved?
                        ExpenseMailer.with(user: employee, type: expense.expense_type, description: expense.description, applied_amount: expense.amount, approved_amount: expense.amount).approve_message.deliver_now
                    elsif expense.rejected?
                        ExpenseMailer.with(user: employee, type: expense.expense_type, applied_amount: expense.amount, description: expense.description, approved_amount: expense.amount).reject_message.deliver_now
                    end
                else
                    render json: { error: { message: "Not valid" } }, status: :bad_request
                end
            elsif !(expense_group.nil?)
                if !(expense_group.submitted?)
                    render json: { error: { message: "Expense group has either been approved already or not submitted yet. You cant approve it."} }, status: :bad_request
                elsif expense_group.submitted?
                    if expense.expense_system_validate == true && expense.pending? 
                        expense.update(data)
                        render json: { message: "status updated!"}, status: :ok
                        expense_group_status(expense_group)
                    else
                        render json: { error: { message: "Not valid" } }, status: :bad_request
                    end
                end
            else
                render json: { error: { message: "Not valid" } }, status: :bad_request
            end
        end
    end


    private
    def set_details
        @user = Employee.find_by(id: params[:emp_id])
        @employee = Employee.find_by(id: params[:employee_id])
        @expense_group = @employee.expense_groups.find_by(id: params[:expense_group_id])
    end
end
