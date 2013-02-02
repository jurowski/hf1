require 'test_helper'

class LevelGoalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:level_goals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create level_goal" do
    assert_difference('LevelGoal.count') do
      post :create, :level_goal => { }
    end

    assert_redirected_to level_goal_path(assigns(:level_goal))
  end

  test "should show level_goal" do
    get :show, :id => level_goals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => level_goals(:one).to_param
    assert_response :success
  end

  test "should update level_goal" do
    put :update, :id => level_goals(:one).to_param, :level_goal => { }
    assert_redirected_to level_goal_path(assigns(:level_goal))
  end

  test "should destroy level_goal" do
    assert_difference('LevelGoal.count', -1) do
      delete :destroy, :id => level_goals(:one).to_param
    end

    assert_redirected_to level_goals_path
  end
end
