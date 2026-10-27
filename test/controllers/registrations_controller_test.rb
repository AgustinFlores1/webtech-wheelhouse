require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "the sign-up page is open to visitors" do
    get new_registration_path
    assert_response :success
  end

  test "signing up creates an account and signs it in" do
    assert_difference -> { User.count }, 1 do
      post registration_path, params: { user: {
        email_address: "New@Wheelhouse.cl", password: "a-long-password", password_confirmation: "a-long-password"
      } }
    end

    assert_redirected_to root_path
    assert cookies[:session_id].present?
    assert_equal "new@wheelhouse.cl", User.last.email_address
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

  test "a refused sign-up answers 422, keeps the email and empties the passwords" do
    assert_no_difference -> { User.count } do
      post registration_path, params: { user: {
        email_address: "short@wheelhouse.cl", password: "short", password_confirmation: "short"
      } }
    end

    assert_response :unprocessable_content
    assert_select "input[name=?][value=?]", "user[email_address]", "short@wheelhouse.cl"
    assert_select "input[name=?][value]", "user[password]", count: 0
    assert_select ".invalid-feedback", /minimum is #{User::PASSWORD_MINIMUM_LENGTH} characters/
    assert_nil cookies[:session_id]
  end
end