require 'test_helper'

class MessageTagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_tag" do
    assert_difference('MessageTag.count') do
      post :create, :message_tag => { }
    end

    assert_redirected_to message_tag_path(assigns(:message_tag))
  end

  test "should show message_tag" do
    get :show, :id => message_tags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_tags(:one).to_param
    assert_response :success
  end

  test "should update message_tag" do
    put :update, :id => message_tags(:one).to_param, :message_tag => { }
    assert_redirected_to message_tag_path(assigns(:message_tag))
  end

  test "should destroy message_tag" do
    assert_difference('MessageTag.count', -1) do
      delete :destroy, :id => message_tags(:one).to_param
    end

    assert_redirected_to message_tags_path
  end
end
