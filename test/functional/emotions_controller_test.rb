require 'test_helper'

class EmotionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emotions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emotion" do
    assert_difference('Emotion.count') do
      post :create, :emotion => { }
    end

    assert_redirected_to emotion_path(assigns(:emotion))
  end

  test "should show emotion" do
    get :show, :id => emotions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => emotions(:one).to_param
    assert_response :success
  end

  test "should update emotion" do
    put :update, :id => emotions(:one).to_param, :emotion => { }
    assert_redirected_to emotion_path(assigns(:emotion))
  end

  test "should destroy emotion" do
    assert_difference('Emotion.count', -1) do
      delete :destroy, :id => emotions(:one).to_param
    end

    assert_redirected_to emotions_path
  end
end
