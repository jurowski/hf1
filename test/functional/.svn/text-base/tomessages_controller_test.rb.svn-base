require 'test_helper'

class TomessagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tomessages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tomessage" do
    assert_difference('Tomessage.count') do
      post :create, :tomessage => { }
    end

    assert_redirected_to tomessage_path(assigns(:tomessage))
  end

  test "should show tomessage" do
    get :show, :id => tomessages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tomessages(:one).to_param
    assert_response :success
  end

  test "should update tomessage" do
    put :update, :id => tomessages(:one).to_param, :tomessage => { }
    assert_redirected_to tomessage_path(assigns(:tomessage))
  end

  test "should destroy tomessage" do
    assert_difference('Tomessage.count', -1) do
      delete :destroy, :id => tomessages(:one).to_param
    end

    assert_redirected_to tomessages_path
  end
end
