require 'test_helper'

class CheersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cheers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cheer" do
    assert_difference('Cheer.count') do
      post :create, :cheer => { }
    end

    assert_redirected_to cheer_path(assigns(:cheer))
  end

  test "should show cheer" do
    get :show, :id => cheers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cheers(:one).to_param
    assert_response :success
  end

  test "should update cheer" do
    put :update, :id => cheers(:one).to_param, :cheer => { }
    assert_redirected_to cheer_path(assigns(:cheer))
  end

  test "should destroy cheer" do
    assert_difference('Cheer.count', -1) do
      delete :destroy, :id => cheers(:one).to_param
    end

    assert_redirected_to cheers_path
  end
end
