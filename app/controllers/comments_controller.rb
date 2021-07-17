class CommentsController < ApplicationController

    before_action :set_user_and_check_authorization, only: [:create]
    before_action :set_details, only: [:index, :reply_comment, :create, :delete_admin_comment, :delete_comment]


    # GET expenses/1/comments
    def index 
        @comments = @expense.comments.all
        render json: @comments
    end


    # POST expenses/1/comments
    def create
        @employee = Employee.find_by(id: @expense.employee_id)
        if @user.id == @employee.id
            render json: "Error - Admin and employee should not be the same" 
        else
            @comment = @expense.comments.create!(params.permit(%i[parent_id description]))
            @comment.update(created_by: params[:emp_id])
            if @comment.save
                CommentMailer.with(user: @employee, admin: @user, comment: @comment, title: @expense.description).comment_message.deliver_now
                render :create
            else
                render json: "error" 
            end
        end
    end


    # POST employees/2/expenses/1/comments/1/reply_comment
    def reply_comment
        @user = Employee.find_by(id: params[:emp_id])
        @employee = Employee.find_by(id: @expense.employee_id)
        @comment = @expense.comments.create(params.permit(%i[description]))
        parent_id = params[:comment_id]
        if Comment.exists?(id: parent_id) || @comment.parent_id == 0  
            if (@user.admin? || @user.id == @employee.id)
                @comment.update(parent_id: parent_id)
                @comment.update(created_by: params[:emp_id])
                @comment.save
                render :reply_comment
                if @user.admin? && @user.id != @employee.id
                    CommentMailer.with(user: @employee, admin: @user, comment: @comment, title: @expense.description).comment_message.deliver_now
                end
            else
                render json: "User not authorized to do this action"
            end
        else
            render json: "No such id"
        end
    end
    

    # DELETE expenses/1/comments/1/delete_comment
    def delete_comment
        @user = Employee.find_by(id: params[:emp_id])
        @comment = @expense.comments.find_by(id: params[:comment_id])
        if @comment.created_by == @user.id
            @comment.destroy
            render json: "Comment successfully deleted"
        else
            render json: "User can only delete their own comments"
        end
    end

    private
    def set_details
        @expense = Expense.find_by(id: params[:expense_id])
    end
end
