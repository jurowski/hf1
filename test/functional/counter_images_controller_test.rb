require 'test_helper'

class CounterImagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counter_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create counter_image" do
    assert_difference('CounterImage.count') do
      post :create, :counter_image => { }
    end

    assert_redirected_to counter_image_path(assigns(:counter_image))
  end

  test "should show counter_image" do
    get :show, :id => counter_images(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => counter_images(:one).to_param
    assert_response :success
  end

  test "should update counter_image" do
    put :update, :id => counter_images(:one).to_param, :counter_image => { }
    assert_redirected_to counter_image_path(assigns(:counter_image))
  end

  test "should destroy counter_image" do
    assert_difference('CounterImage.count', -1) do
      delete :destroy, :id => counter_images(:one).to_param
    end

    assert_redirected_to counter_images_path
  end
end
