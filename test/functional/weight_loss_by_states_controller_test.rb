require 'test_helper'

class WeightLossByStatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weight_loss_by_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weight_loss_by_state" do
    assert_difference('WeightLossByState.count') do
      post :create, :weight_loss_by_state => { }
    end

    assert_redirected_to weight_loss_by_state_path(assigns(:weight_loss_by_state))
  end

  test "should show weight_loss_by_state" do
    get :show, :id => weight_loss_by_states(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => weight_loss_by_states(:one).to_param
    assert_response :success
  end

  test "should update weight_loss_by_state" do
    put :update, :id => weight_loss_by_states(:one).to_param, :weight_loss_by_state => { }
    assert_redirected_to weight_loss_by_state_path(assigns(:weight_loss_by_state))
  end

  test "should destroy weight_loss_by_state" do
    assert_difference('WeightLossByState.count', -1) do
      delete :destroy, :id => weight_loss_by_states(:one).to_param
    end

    assert_redirected_to weight_loss_by_states_path
  end
end
