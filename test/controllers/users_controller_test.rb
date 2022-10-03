require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:carlos)
  end

  test "should get show" do
    get users_url(@user.username)
    assert_response :success
  end
end
