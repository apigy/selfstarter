require 'test_helper'

class PreorderControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get checkout" do
    get :checkout
    assert_response :success
  end

  test "should get get_excited" do
    get :get_excited
    assert_response :success
  end
end
