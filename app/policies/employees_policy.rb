class EmployeesPolicy < ApplicationPolicy

    def search_employee?
        user.admin?
    end

    def delete_employee?
        user.admin?
    end

    def delete_comment?
        user.admin?
    end

    def terminate?
        user.admin?
    end

    def update_status?
        user.admin?
    end

    def update_expense_status?
        user.admin?
    end

    def create?
        user.admin?
    end

    def delete_admin_comment?
        user.admin?
    end

    def set_user_and_check_authorization?
        user.admin?
    end
end
