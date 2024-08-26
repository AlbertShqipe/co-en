require "test_helper"

class GroupFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get group_forms_index_url
    assert_response :success
  end

  test "should get show" do
    get group_forms_show_url
    assert_response :success
  end

  test "should get new" do
    get group_forms_new_url
    assert_response :success
  end

  test "should get create" do
    get group_forms_create_url
    assert_response :success
  end

  test "should get info" do
    get group_forms_info_url
    assert_response :success
  end
end
