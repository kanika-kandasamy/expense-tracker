require 'net/http'
require 'uri'
require 'json'

class ApplicationController < ActionController::API
    include Pundit


    def set_user_and_check_authorization
        @user = Employee.find_by(id: params[:emp_id])
        Current.user = @user
        authorize @user, policy_class: EmployeesPolicy
        rescue Pundit::NotAuthorizedError
            render json: "User not authorized to do this action"
    end


    def system_check(expense, employee, expense_group)
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

        resp = response.body
=begin
        variable = JSON.parse resp.gsub('=>', ':')
        if variable['status'] == true
=end
        if expense.invoice_number % 2 == 0
            expense.update(expense_system_validate: true)
        else
            expense.update(expense_system_validate: false)
            expense.update(status: "rejected_by_system")
            ExpenseMailer.with(user: employee, type: expense.expense_type, rejected: expense.description, applied_amount: expense.amount, approved_amount: expense.amount).system_reject_message.deliver_now
            if !(expense_group.nil?)
            ExpenseGroupMailer.with(user: employee, title: expense_group.title, rejected: expense.description, type: expense.expense_type, applied_amount: expense.amount).reject_message.deliver_now
            end
        end
    end


    private

    def current_user
        current_user = Current.user
    end
 
end
