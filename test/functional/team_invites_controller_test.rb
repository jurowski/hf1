require 'test_helper'

class TeamInvitesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:team_invites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team_invite" do
    assert_difference('TeamInvite.count') do
      post :create, :team_invite => { }
    end

    assert_redirected_to team_invite_path(assigns(:team_invite))
  end

  test "should show team_invite" do
    get :show, :id => team_invites(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => team_invites(:one).to_param
    assert_response :success
  end

  test "should update team_invite" do
    put :update, :id => team_invites(:one).to_param, :team_invite => { }
    assert_redirected_to team_invite_path(assigns(:team_invite))
  end

  test "should destroy team_invite" do
    assert_difference('TeamInvite.count', -1) do
      delete :destroy, :id => team_invites(:one).to_param
    end

    assert_redirected_to team_invites_path
  end
end
