require 'test_helper'

class CoachMotivationTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coach_motivation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coach_motivation_type" do
    assert_difference('CoachMotivationType.count') do
      post :create, :coach_motivation_type => { }
    end

    assert_redirected_to coach_motivation_type_path(assigns(:coach_motivation_type))
  end

  test "should show coach_motivation_type" do
    get :show, :id => coach_motivation_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => coach_motivation_types(:one).to_param
    assert_response :success
  end

  test "should update coach_motivation_type" do
    put :update, :id => coach_motivation_types(:one).to_param, :coach_motivation_type => { }
    assert_redirected_to coach_motivation_type_path(assigns(:coach_motivation_type))
  end

  test "should destroy coach_motivation_type" do
    assert_difference('CoachMotivationType.count', -1) do
      delete :destroy, :id => coach_motivation_types(:one).to_param
    end

    assert_redirected_to coach_motivation_types_path
  end
end
