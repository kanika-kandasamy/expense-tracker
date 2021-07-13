class CommentMailer < ApplicationMailer


  def comment_message
    mail(to: params[:user].email, subject: "Someone commented on your expense report - Regarding")
  end

end
