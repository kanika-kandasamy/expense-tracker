class EmployeesController < ApplicationController
    ALLOWED_DATA = %[email name contact department active_status].freeze
=begin
    def index
        employees = Employee.all
        render json: employees
    end
=end
    def create
        data = json_payload.select { |instance| ALLOWED_DATA.include? instance}
        employee = Employee.new(data)
        if employee.save
            render json: employee
        else
            render json: "error" 
        end
    end

    def show
        @employee = Employee.find_by(id: params[:id])
        render :show
    end

    def show_employees
        user = Employee.find_by(id: params[:id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        @employees = Employee.all
        render :show_employees
    end

    def terminate
        employee = Employee.find_by(id: params[:id])
        employee.update(active_status: false)
    end

    def search_employee
        user = Employee.find_by(id: params[:u_id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        @employee = Employee.find_by(id: params[:emp_id])
        render :search_employee
        #render json: employee.expenses
    end

    def delete_employee
        user = Employee.find_by(id: params[:id])
        Current.user = user
        authorize user, policy_class: EmployeesPolicy
        employee = Employee.find_by(id: params[:e_id])
        if user.id == employee.id
            render json: "Error" 
        else
            if employee.destroy
                render json: "Employee deleted!"
            else
                render json: "error"
            end
        end
    end
end
