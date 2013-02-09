require 'test_helper'

class MessageEmotionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_emotions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_emotion" do
    assert_difference('MessageEmotion.count') do
      post :create, :message_emotion => { }
    end

    assert_redirected_to message_emotion_path(assigns(:message_emotion))
  end

  test "should show message_emotion" do
    get :show, :id => message_emotions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_emotions(:one).to_param
    assert_response :success
  end

  test "should update message_emotion" do
    put :update, :id => message_emotions(:one).to_param, :message_emotion => { }
    assert_redirected_to message_emotion_path(assigns(:message_emotion))
  end

  test "should destroy message_emotion" do
    assert_difference('MessageEmotion.count', -1) do
      delete :destroy, :id => message_emotions(:one).to_param
    end

    assert_redirected_to message_emotions_path
  end
end
