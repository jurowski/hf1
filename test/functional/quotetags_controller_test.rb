require 'test_helper'

class QuotetagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotetags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotetags" do
    assert_difference('Quotetags.count') do
      post :create, :quotetags => { }
    end

    assert_redirected_to quotetags_path(assigns(:quotetags))
  end

  test "should show quotetags" do
    get :show, :id => quotetags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => quotetags(:one).to_param
    assert_response :success
  end

  test "should update quotetags" do
    put :update, :id => quotetags(:one).to_param, :quotetags => { }
    assert_redirected_to quotetags_path(assigns(:quotetags))
  end

  test "should destroy quotetags" do
    assert_difference('Quotetags.count', -1) do
      delete :destroy, :id => quotetags(:one).to_param
    end

    assert_redirected_to quotetags_path
  end
end
