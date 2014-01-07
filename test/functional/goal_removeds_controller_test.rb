require 'test_helper'

class GoalRemovedsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:goal_removeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create goal_removed" do
    assert_difference('GoalRemoved.count') do
      post :create, :goal_removed => { }
    end

    assert_redirected_to goal_removed_path(assigns(:goal_removed))
  end

  test "should show goal_removed" do
    get :show, :id => goal_removeds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => goal_removeds(:one).to_param
    assert_response :success
  end

  test "should update goal_removed" do
    put :update, :id => goal_removeds(:one).to_param, :goal_removed => { }
    assert_redirected_to goal_removed_path(assigns(:goal_removed))
  end

  test "should destroy goal_removed" do
    assert_difference('GoalRemoved.count', -1) do
      delete :destroy, :id => goal_removeds(:one).to_param
    end

    assert_redirected_to goal_removeds_path
  end
end
