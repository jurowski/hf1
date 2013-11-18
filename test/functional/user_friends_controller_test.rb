require 'test_helper'

class UserFriendsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_friends)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_friend" do
    assert_difference('UserFriend.count') do
      post :create, :user_friend => { }
    end

    assert_redirected_to user_friend_path(assigns(:user_friend))
  end

  test "should show user_friend" do
    get :show, :id => user_friends(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_friends(:one).to_param
    assert_response :success
  end

  test "should update user_friend" do
    put :update, :id => user_friends(:one).to_param, :user_friend => { }
    assert_redirected_to user_friend_path(assigns(:user_friend))
  end

  test "should destroy user_friend" do
    assert_difference('UserFriend.count', -1) do
      delete :destroy, :id => user_friends(:one).to_param
    end

    assert_redirected_to user_friends_path
  end
end
