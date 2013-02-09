require 'test_helper'

class MessageMotivationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_motivations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_motivation" do
    assert_difference('MessageMotivation.count') do
      post :create, :message_motivation => { }
    end

    assert_redirected_to message_motivation_path(assigns(:message_motivation))
  end

  test "should show message_motivation" do
    get :show, :id => message_motivations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_motivations(:one).to_param
    assert_response :success
  end

  test "should update message_motivation" do
    put :update, :id => message_motivations(:one).to_param, :message_motivation => { }
    assert_redirected_to message_motivation_path(assigns(:message_motivation))
  end

  test "should destroy message_motivation" do
    assert_difference('MessageMotivation.count', -1) do
      delete :destroy, :id => message_motivations(:one).to_param
    end

    assert_redirected_to message_motivations_path
  end
end
