require 'test_helper'

class OrganizationUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_user" do
    assert_difference('OrganizationUser.count') do
      post :create, :organization_user => { }
    end

    assert_redirected_to organization_user_path(assigns(:organization_user))
  end

  test "should show organization_user" do
    get :show, :id => organization_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => organization_users(:one).to_param
    assert_response :success
  end

  test "should update organization_user" do
    put :update, :id => organization_users(:one).to_param, :organization_user => { }
    assert_redirected_to organization_user_path(assigns(:organization_user))
  end

  test "should destroy organization_user" do
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, :id => organization_users(:one).to_param
    end

    assert_redirected_to organization_users_path
  end
end
