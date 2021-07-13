require "test_helper"

class CommentMailerTest < ActionMailer::TestCase
  test "comment_message" do
    mail = CommentMailer.comment_message
    assert_equal "Comment message", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
