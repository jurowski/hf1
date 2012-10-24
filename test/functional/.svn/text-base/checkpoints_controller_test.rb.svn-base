require 'test_helper'

class CheckpointsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkpoints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkpoint" do
    assert_difference('Checkpoint.count') do
      post :create, :checkpoint => { }
    end

    assert_redirected_to checkpoint_path(assigns(:checkpoint))
  end

  test "should show checkpoint" do
    get :show, :id => checkpoints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => checkpoints(:one).to_param
    assert_response :success
  end

  test "should update checkpoint" do
    put :update, :id => checkpoints(:one).to_param, :checkpoint => { }
    assert_redirected_to checkpoint_path(assigns(:checkpoint))
  end

  test "should destroy checkpoint" do
    assert_difference('Checkpoint.count', -1) do
      delete :destroy, :id => checkpoints(:one).to_param
    end

    assert_redirected_to checkpoints_path
  end
end
