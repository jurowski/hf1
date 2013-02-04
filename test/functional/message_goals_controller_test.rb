require 'test_helper'

class MessageGoalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_goals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_goal" do
    assert_difference('MessageGoal.count') do
      post :create, :message_goal => { }
    end

    assert_redirected_to message_goal_path(assigns(:message_goal))
  end

  test "should show message_goal" do
    get :show, :id => message_goals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_goals(:one).to_param
    assert_response :success
  end

  test "should update message_goal" do
    put :update, :id => message_goals(:one).to_param, :message_goal => { }
    assert_redirected_to message_goal_path(assigns(:message_goal))
  end

  test "should destroy message_goal" do
    assert_difference('MessageGoal.count', -1) do
      delete :destroy, :id => message_goals(:one).to_param
    end

    assert_redirected_to message_goals_path
  end
end
