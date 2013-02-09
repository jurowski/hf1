require 'test_helper'

class UserMotivationTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_motivation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_motivation_type" do
    assert_difference('UserMotivationType.count') do
      post :create, :user_motivation_type => { }
    end

    assert_redirected_to user_motivation_type_path(assigns(:user_motivation_type))
  end

  test "should show user_motivation_type" do
    get :show, :id => user_motivation_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_motivation_types(:one).to_param
    assert_response :success
  end

  test "should update user_motivation_type" do
    put :update, :id => user_motivation_types(:one).to_param, :user_motivation_type => { }
    assert_redirected_to user_motivation_type_path(assigns(:user_motivation_type))
  end

  test "should destroy user_motivation_type" do
    assert_difference('UserMotivationType.count', -1) do
      delete :destroy, :id => user_motivation_types(:one).to_param
    end

    assert_redirected_to user_motivation_types_path
  end
end
