require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get like" do
    get :like
    assert_response :success
  end

  test "should get likelist" do
    get :likelist
    assert_response :success
  end

  test "should get block" do
    get :block
    assert_response :success
  end

  test "should get talk" do
    get :talk
    assert_response :success
  end

end
