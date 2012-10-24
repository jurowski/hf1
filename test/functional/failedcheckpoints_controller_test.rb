require 'test_helper'

class FailedcheckpointsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:failedcheckpoints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create failedcheckpoint" do
    assert_difference('Failedcheckpoint.count') do
      post :create, :failedcheckpoint => { }
    end

    assert_redirected_to failedcheckpoint_path(assigns(:failedcheckpoint))
  end

  test "should show failedcheckpoint" do
    get :show, :id => failedcheckpoints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => failedcheckpoints(:one).to_param
    assert_response :success
  end

  test "should update failedcheckpoint" do
    put :update, :id => failedcheckpoints(:one).to_param, :failedcheckpoint => { }
    assert_redirected_to failedcheckpoint_path(assigns(:failedcheckpoint))
  end

  test "should destroy failedcheckpoint" do
    assert_difference('Failedcheckpoint.count', -1) do
      delete :destroy, :id => failedcheckpoints(:one).to_param
    end

    assert_redirected_to failedcheckpoints_path
  end
end
