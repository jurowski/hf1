require 'test_helper'

class FrommessagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:frommessages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frommessage" do
    assert_difference('Frommessage.count') do
      post :create, :frommessage => { }
    end

    assert_redirected_to frommessage_path(assigns(:frommessage))
  end

  test "should show frommessage" do
    get :show, :id => frommessages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => frommessages(:one).to_param
    assert_response :success
  end

  test "should update frommessage" do
    put :update, :id => frommessages(:one).to_param, :frommessage => { }
    assert_redirected_to frommessage_path(assigns(:frommessage))
  end

  test "should destroy frommessage" do
    assert_difference('Frommessage.count', -1) do
      delete :destroy, :id => frommessages(:one).to_param
    end

    assert_redirected_to frommessages_path
  end
end
