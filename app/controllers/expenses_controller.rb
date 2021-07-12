require 'net/http'
require 'uri'
require 'json'

class ExpensesController < ApplicationController
    ALLOWED_DATA = %[employee_id expense_group_id invoice_number date description amount attachment status].freeze
    def index
        expense = Expense.group(:expense_group_id)
        render json: expense
    end

    def create_expense
        employee = Employee.find_by(id: params[:id])
        if employee.active_status == true
            expense_group = employee.expense_groups.find_by(id: params[:expg_id])
            data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
            expense = expense_group.expenses.new(data)
            if expense.save
                system_check(expense)
                render json: expense
            else
                render json: "error" 
            end
        end
    end


    #status = ( curl -H {"X-API-Key: b490bb80"} -X { POST -d {990} } ) + ( "https://my.api.mockaroo.com/invoices.json" )
    def system_check(expense)
        invoice = expense.invoice_number
        if invoice % 2 == 0  
            expense.update(expense_system_validate: true)
        elsif invoice % 2 != 0 
            expense.update(status: "Rejected")
        end            
    end


    def show_expenses
        employee = Employee.find_by(id: params[:id])
        expense_group = employee.expense_groups.find_by(id: params[:ex_g_id])
        render json: expense_group.expenses
    end

    def delete_expense
        employee = Employee.find_by(id: params[:id])
        expense_group = employee.expense_groups.find_by(id: params[:expg_id])
        expense = expense_groups.expenses.find_by(id: params[:exp_id])
        if expense.destroy
            render json: "Expense deleted!"
        else
            render json: "error" 
        end
    end

    def expense_status
        user = Employee.find_by(id: params[:id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        employee = Employee.find_by(id: params[:emp_id])
        if user.id == employee.id
            render json: "Error : Users cannot approve their own requests"
        end
        expense_group = employee.expense_groups.find_by(id: params[:expg_id])
        expense = expense_group.expenses.find_by(id: params[:exp_id])
        data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
        if expense.expense_system_validate == true
            expense.update(data)
        else 
            render json: "Not valid"
        end
    end

=begin
    def invoice_validator(expense)
        uri = URI.parse("https://my.api.mockaroo.com/invoices.json")
        request = Net::HTTP::Post.new(uri)
        request["X-Api-Key"] = "b490bb80"
        request.body = JSON.dump({
        "invoice_id" => expense.invoice_number
        })

        req_options = {
        use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end

        # response.code
        resp = response.body
        puts resp
        if resp.end_with?("true") 
            expense.update(expense_system_check: true)
        else
            expense.update(expense_system_check: false)
            expense.update(status: "Rejected")
        end
    end
=end
end

