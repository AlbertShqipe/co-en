require "test_helper"

class ProfessorsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get professors_new_url
    assert_response :success
  end

  test "should get create" do
    get professors_create_url
    assert_response :success
  end
end
