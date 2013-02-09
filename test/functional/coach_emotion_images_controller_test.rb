require 'test_helper'

class CoachEmotionImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coach_emotion_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coach_emotion_image" do
    assert_difference('CoachEmotionImage.count') do
      post :create, :coach_emotion_image => { }
    end

    assert_redirected_to coach_emotion_image_path(assigns(:coach_emotion_image))
  end

  test "should show coach_emotion_image" do
    get :show, :id => coach_emotion_images(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => coach_emotion_images(:one).to_param
    assert_response :success
  end

  test "should update coach_emotion_image" do
    put :update, :id => coach_emotion_images(:one).to_param, :coach_emotion_image => { }
    assert_redirected_to coach_emotion_image_path(assigns(:coach_emotion_image))
  end

  test "should destroy coach_emotion_image" do
    assert_difference('CoachEmotionImage.count', -1) do
      delete :destroy, :id => coach_emotion_images(:one).to_param
    end

    assert_redirected_to coach_emotion_images_path
  end
end
