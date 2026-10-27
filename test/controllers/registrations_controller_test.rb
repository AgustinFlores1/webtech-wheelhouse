require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "the sign-up page is open to visitors" do
    get new_registration_path
    assert_response :success
  end

  test "signing up creates an account, signs it in, and queues the welcome email" do
    assert_difference -> { User.count }, 1 do
      assert_enqueued_emails 1 do
        post registration_path, params: { user: {
          email_address: "New@Wheelhouse.cl", password: "a-long-password", password_confirmation: "a-long-password"
        } }
      end
    end

    assert_redirected_to root_path
    assert cookies[:session_id].present?
    assert_enqueued_email_with WelcomeMailer, :welcome, args: [ User.last ]
  end

  test "a role or a staff member written by hand is ignored" do
    post registration_path, params: { user: {
      email_address: "sneaky@wheelhouse.cl", password: "a-long-password", password_confirmation: "a-long-password",
      role: "owner", staff_member_id: 1
    } }

    user = User.find_by!(email_address: "sneaky@wheelhouse.cl")
    assert_equal User.column_defaults["role"], user.role
    assert_nil user.staff_member_id
  end

  test "a refused sign-up answers 422, keeps the email, empties the passwords and sends nothing" do
    assert_no_difference -> { User.count } do
      assert_no_enqueued_emails do
        post registration_path, params: { user: {
          email_address: "short@wheelhouse.cl", password: "short", password_confirmation: "short"
        } }
      end
    end

    assert_response :unprocessable_content
    # ... the assert_select lines you already have stay the same
  end
end
