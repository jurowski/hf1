require 'test_helper'

class BetpayeesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:betpayees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create betpayee" do
    assert_difference('Betpayee.count') do
      post :create, :betpayee => { }
    end

    assert_redirected_to betpayee_path(assigns(:betpayee))
  end

  test "should show betpayee" do
    get :show, :id => betpayees(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => betpayees(:one).to_param
    assert_response :success
  end

  test "should update betpayee" do
    put :update, :id => betpayees(:one).to_param, :betpayee => { }
    assert_redirected_to betpayee_path(assigns(:betpayee))
  end

  test "should destroy betpayee" do
    assert_difference('Betpayee.count', -1) do
      delete :destroy, :id => betpayees(:one).to_param
    end

    assert_redirected_to betpayees_path
  end
end
