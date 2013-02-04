require 'test_helper'

class CheckpointAchievemintsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkpoint_achievemints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkpoint_achievemint" do
    assert_difference('CheckpointAchievemint.count') do
      post :create, :checkpoint_achievemint => { }
    end

    assert_redirected_to checkpoint_achievemint_path(assigns(:checkpoint_achievemint))
  end

  test "should show checkpoint_achievemint" do
    get :show, :id => checkpoint_achievemints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => checkpoint_achievemints(:one).to_param
    assert_response :success
  end

  test "should update checkpoint_achievemint" do
    put :update, :id => checkpoint_achievemints(:one).to_param, :checkpoint_achievemint => { }
    assert_redirected_to checkpoint_achievemint_path(assigns(:checkpoint_achievemint))
  end

  test "should destroy checkpoint_achievemint" do
    assert_difference('CheckpointAchievemint.count', -1) do
      delete :destroy, :id => checkpoint_achievemints(:one).to_param
    end

    assert_redirected_to checkpoint_achievemints_path
  end
end
