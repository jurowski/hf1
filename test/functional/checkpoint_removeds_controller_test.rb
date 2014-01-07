require 'test_helper'

class CheckpointRemovedsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkpoint_removeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkpoint_removed" do
    assert_difference('CheckpointRemoved.count') do
      post :create, :checkpoint_removed => { }
    end

    assert_redirected_to checkpoint_removed_path(assigns(:checkpoint_removed))
  end

  test "should show checkpoint_removed" do
    get :show, :id => checkpoint_removeds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => checkpoint_removeds(:one).to_param
    assert_response :success
  end

  test "should update checkpoint_removed" do
    put :update, :id => checkpoint_removeds(:one).to_param, :checkpoint_removed => { }
    assert_redirected_to checkpoint_removed_path(assigns(:checkpoint_removed))
  end

  test "should destroy checkpoint_removed" do
    assert_difference('CheckpointRemoved.count', -1) do
      delete :destroy, :id => checkpoint_removeds(:one).to_param
    end

    assert_redirected_to checkpoint_removeds_path
  end
end
