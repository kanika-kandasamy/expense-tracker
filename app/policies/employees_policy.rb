class EmployeesPolicy < ApplicationPolicy

    def expense_status?
        user.admin?
    end

    def create_comment?
        user.admin?
    end

    def search_employee?
        user.admin?
    end

    def delete_employee?
        user.admin?
    end

    def expense_group_status?
        user.admin?
    end

    def delete_comment?
        user.admin?
    end

    def show_employees?
        user.admin?
    end
end