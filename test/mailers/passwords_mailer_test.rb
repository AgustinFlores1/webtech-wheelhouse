require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "the reset email comes from Wheelhouse, has both parts and a full link" do
    user = users(:one)
    mail = PasswordsMailer.reset(user)

    assert_equal [ user.email_address ], mail.to
    assert_match "Wheelhouse", mail[:from].to_s
    assert_match "Wheelhouse", mail.subject

    assert mail.html_part, "the email should have an HTML part"
    assert mail.text_part, "the email should have a text part"

    [ mail.html_part, mail.text_part ].each do |part|
      body = part.body.to_s
      assert_match "Wheelhouse", body
      assert_match %r{http://[^/\s]+/passwords/[^/\s]+/edit}, body
    end
  end
end