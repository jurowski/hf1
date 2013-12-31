require 'test_helper'

class ProgramSessionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_session" do
    assert_difference('ProgramSession.count') do
      post :create, :program_session => { }
    end

    assert_redirected_to program_session_path(assigns(:program_session))
  end

  test "should show program_session" do
    get :show, :id => program_sessions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => program_sessions(:one).to_param
    assert_response :success
  end

  test "should update program_session" do
    put :update, :id => program_sessions(:one).to_param, :program_session => { }
    assert_redirected_to program_session_path(assigns(:program_session))
  end

  test "should destroy program_session" do
    assert_difference('ProgramSession.count', -1) do
      delete :destroy, :id => program_sessions(:one).to_param
    end

    assert_redirected_to program_sessions_path
  end
end
