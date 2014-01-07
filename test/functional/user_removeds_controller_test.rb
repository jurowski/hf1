require 'test_helper'

class UserRemovedsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_removeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_removed" do
    assert_difference('UserRemoved.count') do
      post :create, :user_removed => { }
    end

    assert_redirected_to user_removed_path(assigns(:user_removed))
  end

  test "should show user_removed" do
    get :show, :id => user_removeds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_removeds(:one).to_param
    assert_response :success
  end

  test "should update user_removed" do
    put :update, :id => user_removeds(:one).to_param, :user_removed => { }
    assert_redirected_to user_removed_path(assigns(:user_removed))
  end

  test "should destroy user_removed" do
    assert_difference('UserRemoved.count', -1) do
      delete :destroy, :id => user_removeds(:one).to_param
    end

    assert_redirected_to user_removeds_path
  end
end
