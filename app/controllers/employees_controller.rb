class EmployeesController < ApplicationController
    before_action :set_user_and_check_authorization, only: [:search_employee, :terminate, :delete_employee, :create]

    # GET /employees
    def index
        employees = Employee.all
        render json: employees
    end


    # POST employees
    def create
        Employee.create!(params.permit(%i[email name department gender contact admin]))
    end


    # GET /employees/1
    def show
        @employee = Employee.find_by(id: params[:id])
        render :show_employees
    end

    # PATCH employees/1
    def update
        employee = Employee.find_by(id: params[:id])
        employee.update(params.permit(%i[contact]))
    end    

    # PATCH employees/1/delete_employee
    # params - emp_id => request_params
    def terminate
        employee = Employee.find_by(id: params[:employee_id])
        employee.update(active_status: false)
        render json: "Employee terminated"
    end


    # GET employees/1/delete_employee
    # params - emp_id => request_params
    def search_employee
        @employee = Employee.find_by(id: params[:employee_id])
        render :search_employee
    end

end
