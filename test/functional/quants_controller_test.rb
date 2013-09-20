require 'test_helper'

class QuantsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quant" do
    assert_difference('Quant.count') do
      post :create, :quant => { }
    end

    assert_redirected_to quant_path(assigns(:quant))
  end

  test "should show quant" do
    get :show, :id => quants(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => quants(:one).to_param
    assert_response :success
  end

  test "should update quant" do
    put :update, :id => quants(:one).to_param, :quant => { }
    assert_redirected_to quant_path(assigns(:quant))
  end

  test "should destroy quant" do
    assert_difference('Quant.count', -1) do
      delete :destroy, :id => quants(:one).to_param
    end

    assert_redirected_to quants_path
  end
end
