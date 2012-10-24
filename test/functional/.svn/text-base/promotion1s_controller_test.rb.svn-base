require 'test_helper'

class Promotion1sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promotion1s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create promotion1" do
    assert_difference('Promotion1.count') do
      post :create, :promotion1 => { }
    end

    assert_redirected_to promotion1_path(assigns(:promotion1))
  end

  test "should show promotion1" do
    get :show, :id => promotion1s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => promotion1s(:one).to_param
    assert_response :success
  end

  test "should update promotion1" do
    put :update, :id => promotion1s(:one).to_param, :promotion1 => { }
    assert_redirected_to promotion1_path(assigns(:promotion1))
  end

  test "should destroy promotion1" do
    assert_difference('Promotion1.count', -1) do
      delete :destroy, :id => promotion1s(:one).to_param
    end

    assert_redirected_to promotion1s_path
  end
end
