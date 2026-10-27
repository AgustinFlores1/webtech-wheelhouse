require "test_helper"

class WelcomeMailerTest < ActionMailer::TestCase
  test "the welcome email names the account and links to sign in, in both parts" do
    user = users(:one)
    mail = WelcomeMailer.welcome(user)

    assert_equal [ user.email_address ], mail.to
    assert_match "Wheelhouse", mail[:from].to_s
    assert_match "Welcome to Wheelhouse", mail.subject

    assert mail.html_part, "the email should have an HTML part"
    assert mail.text_part, "the email should have a text part"

    [ mail.html_part, mail.text_part ].each do |part|
      body = part.body.to_s
      assert_match user.email_address, body
      assert_match %r{http://[^/\s]+/session/new}, body
    end
  end
end
