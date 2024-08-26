require "test_helper"

class IndividualFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get individual_forms_index_url
    assert_response :success
  end

  test "should get new" do
    get individual_forms_new_url
    assert_response :success
  end

  test "should get create" do
    get individual_forms_create_url
    assert_response :success
  end
end
