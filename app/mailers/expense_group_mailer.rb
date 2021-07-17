class ExpenseGroupMailer < ApplicationMailer
    
    def approve_message
        mail(to: params[:user].email, subject: "Expense reimbursement approval - Regarding")
    end

    def reject_message
        mail(to: params[:user].email, subject: "Expense reimbursement approval - Regarding")
    end
        
end
