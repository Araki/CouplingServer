require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  test "should get top" do
    get :top
    assert_response :success
  end

end
