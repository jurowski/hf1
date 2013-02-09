require 'test_helper'

class MotivationTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:motivation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create motivation_type" do
    assert_difference('MotivationType.count') do
      post :create, :motivation_type => { }
    end

    assert_redirected_to motivation_type_path(assigns(:motivation_type))
  end

  test "should show motivation_type" do
    get :show, :id => motivation_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => motivation_types(:one).to_param
    assert_response :success
  end

  test "should update motivation_type" do
    put :update, :id => motivation_types(:one).to_param, :motivation_type => { }
    assert_redirected_to motivation_type_path(assigns(:motivation_type))
  end

  test "should destroy motivation_type" do
    assert_difference('MotivationType.count', -1) do
      delete :destroy, :id => motivation_types(:one).to_param
    end

    assert_redirected_to motivation_types_path
  end
end
