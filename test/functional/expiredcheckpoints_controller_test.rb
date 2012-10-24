require 'test_helper'

class ExpiredcheckpointsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expiredcheckpoints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expiredcheckpoint" do
    assert_difference('Expiredcheckpoint.count') do
      post :create, :expiredcheckpoint => { }
    end

    assert_redirected_to expiredcheckpoint_path(assigns(:expiredcheckpoint))
  end

  test "should show expiredcheckpoint" do
    get :show, :id => expiredcheckpoints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => expiredcheckpoints(:one).to_param
    assert_response :success
  end

  test "should update expiredcheckpoint" do
    put :update, :id => expiredcheckpoints(:one).to_param, :expiredcheckpoint => { }
    assert_redirected_to expiredcheckpoint_path(assigns(:expiredcheckpoint))
  end

  test "should destroy expiredcheckpoint" do
    assert_difference('Expiredcheckpoint.count', -1) do
      delete :destroy, :id => expiredcheckpoints(:one).to_param
    end

    assert_redirected_to expiredcheckpoints_path
  end
end
