require 'test_helper'

class ImpactLeadersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:impact_leaders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create impact_leader" do
    assert_difference('ImpactLeader.count') do
      post :create, :impact_leader => { }
    end

    assert_redirected_to impact_leader_path(assigns(:impact_leader))
  end

  test "should show impact_leader" do
    get :show, :id => impact_leaders(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => impact_leaders(:one).to_param
    assert_response :success
  end

  test "should update impact_leader" do
    put :update, :id => impact_leaders(:one).to_param, :impact_leader => { }
    assert_redirected_to impact_leader_path(assigns(:impact_leader))
  end

  test "should destroy impact_leader" do
    assert_difference('ImpactLeader.count', -1) do
      delete :destroy, :id => impact_leaders(:one).to_param
    end

    assert_redirected_to impact_leaders_path
  end
end
