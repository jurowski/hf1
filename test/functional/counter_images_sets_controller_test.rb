require 'test_helper'

class CounterImagesSetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counter_images_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create counter_images_set" do
    assert_difference('CounterImagesSet.count') do
      post :create, :counter_images_set => { }
    end

    assert_redirected_to counter_images_set_path(assigns(:counter_images_set))
  end

  test "should show counter_images_set" do
    get :show, :id => counter_images_sets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => counter_images_sets(:one).to_param
    assert_response :success
  end

  test "should update counter_images_set" do
    put :update, :id => counter_images_sets(:one).to_param, :counter_images_set => { }
    assert_redirected_to counter_images_set_path(assigns(:counter_images_set))
  end

  test "should destroy counter_images_set" do
    assert_difference('CounterImagesSet.count', -1) do
      delete :destroy, :id => counter_images_sets(:one).to_param
    end

    assert_redirected_to counter_images_sets_path
  end
end
