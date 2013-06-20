require 'test_helper'

class EncourageItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:encourage_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create encourage_item" do
    assert_difference('EncourageItem.count') do
      post :create, :encourage_item => { }
    end

    assert_redirected_to encourage_item_path(assigns(:encourage_item))
  end

  test "should show encourage_item" do
    get :show, :id => encourage_items(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => encourage_items(:one).to_param
    assert_response :success
  end

  test "should update encourage_item" do
    put :update, :id => encourage_items(:one).to_param, :encourage_item => { }
    assert_redirected_to encourage_item_path(assigns(:encourage_item))
  end

  test "should destroy encourage_item" do
    assert_difference('EncourageItem.count', -1) do
      delete :destroy, :id => encourage_items(:one).to_param
    end

    assert_redirected_to encourage_items_path
  end
end
