require 'test_helper'

class AchievemintsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:achievemints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create achievemint" do
    assert_difference('Achievemint.count') do
      post :create, :achievemint => { }
    end

    assert_redirected_to achievemint_path(assigns(:achievemint))
  end

  test "should show achievemint" do
    get :show, :id => achievemints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => achievemints(:one).to_param
    assert_response :success
  end

  test "should update achievemint" do
    put :update, :id => achievemints(:one).to_param, :achievemint => { }
    assert_redirected_to achievemint_path(assigns(:achievemint))
  end

  test "should destroy achievemint" do
    assert_difference('Achievemint.count', -1) do
      delete :destroy, :id => achievemints(:one).to_param
    end

    assert_redirected_to achievemints_path
  end
end
