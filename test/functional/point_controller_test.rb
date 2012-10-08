require 'test_helper'

class PointControllerTest < ActionController::TestCase
  test "should get add" do
    get :add
    assert_response :success
  end

  test "should get info" do
    get :info
    assert_response :success
  end

  test "should get use" do
    get :use
    assert_response :success
  end

end
