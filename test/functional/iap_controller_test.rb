require 'test_helper'

class IapControllerTest < ActionController::TestCase
  test "should get history" do
    get :history
    assert_response :success
  end

  test "should get pay" do
    get :pay
    assert_response :success
  end

end
