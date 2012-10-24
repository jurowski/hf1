require 'test_helper'

class CoachgoalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coachgoals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coachgoal" do
    assert_difference('Coachgoal.count') do
      post :create, :coachgoal => { }
    end

    assert_redirected_to coachgoal_path(assigns(:coachgoal))
  end

  test "should show coachgoal" do
    get :show, :id => coachgoals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => coachgoals(:one).to_param
    assert_response :success
  end

  test "should update coachgoal" do
    put :update, :id => coachgoals(:one).to_param, :coachgoal => { }
    assert_redirected_to coachgoal_path(assigns(:coachgoal))
  end

  test "should destroy coachgoal" do
    assert_difference('Coachgoal.count', -1) do
      delete :destroy, :id => coachgoals(:one).to_param
    end

    assert_redirected_to coachgoals_path
  end
end
