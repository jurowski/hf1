require 'test_helper'

class TeamgoalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teamgoals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create teamgoal" do
    assert_difference('Teamgoal.count') do
      post :create, :teamgoal => { }
    end

    assert_redirected_to teamgoal_path(assigns(:teamgoal))
  end

  test "should show teamgoal" do
    get :show, :id => teamgoals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => teamgoals(:one).to_param
    assert_response :success
  end

  test "should update teamgoal" do
    put :update, :id => teamgoals(:one).to_param, :teamgoal => { }
    assert_redirected_to teamgoal_path(assigns(:teamgoal))
  end

  test "should destroy teamgoal" do
    assert_difference('Teamgoal.count', -1) do
      delete :destroy, :id => teamgoals(:one).to_param
    end

    assert_redirected_to teamgoals_path
  end
end
