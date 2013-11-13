require 'test_helper'

class CronjobsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cronjobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cronjob" do
    assert_difference('Cronjob.count') do
      post :create, :cronjob => { }
    end

    assert_redirected_to cronjob_path(assigns(:cronjob))
  end

  test "should show cronjob" do
    get :show, :id => cronjobs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cronjobs(:one).to_param
    assert_response :success
  end

  test "should update cronjob" do
    put :update, :id => cronjobs(:one).to_param, :cronjob => { }
    assert_redirected_to cronjob_path(assigns(:cronjob))
  end

  test "should destroy cronjob" do
    assert_difference('Cronjob.count', -1) do
      delete :destroy, :id => cronjobs(:one).to_param
    end

    assert_redirected_to cronjobs_path
  end
end
