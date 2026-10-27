require "test_helper"

class AccessTest < ActionDispatch::IntegrationTest
  setup do
    @service = ServiceCatalog.create!(name: "Flat Tire Repair", current_price: 20)
  end

  test "a visitor can read the list and the page of the services" do
    get service_catalogs_path
    assert_response :success

    get service_catalog_path(@service)
    assert_response :success
  end

  test "a visitor cannot create, edit or delete a service" do
    get new_service_catalog_path
    assert_redirected_to new_session_path

    post service_catalogs_path, params: { service_catalog: { name: "Hacked", current_price: 1 } }
    assert_redirected_to new_session_path

    get edit_service_catalog_path(@service)
    assert_redirected_to new_session_path

    delete service_catalog_path(@service)
    assert_redirected_to new_session_path

    assert ServiceCatalog.exists?(@service.id)
    assert_not ServiceCatalog.exists?(name: "Hacked")
  end

  test "every other page requires a session" do
    [ root_path, workshop_path, about_path, customers_path,
      bikes_path, repairs_path, staff_members_path ].each do |path|
      get path
      assert_redirected_to new_session_path, "#{path} should require a session"
    end
  end

  test "after signing in, the visitor lands on the page they asked for" do
    get repairs_path
    post session_path, params: { email_address: users(:one).email_address, password: "password" }

    assert_redirected_to repairs_url
  end

  test "the navigation bar of a visitor links only to the services and to sign in" do
    get service_catalogs_path

    assert_select "nav a[href=?]", new_session_path
    assert_select "nav a[href=?]", service_catalogs_path
    [ root_path, repairs_path, customers_path, bikes_path, staff_members_path ].each do |path|
      assert_select "nav a[href=?]", path, count: 0
    end
  end

  test "the API does not ask for a session" do
    get api_v1_services_path
    assert_response :success

    get api_v1_repairs_path
    assert_response :unauthorized
  end
end