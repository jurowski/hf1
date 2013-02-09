require 'test_helper'

class ProgramMotivationTypesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_motivation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_motivation_type" do
    assert_difference('ProgramMotivationType.count') do
      post :create, :program_motivation_type => { }
    end

    assert_redirected_to program_motivation_type_path(assigns(:program_motivation_type))
  end

  test "should show program_motivation_type" do
    get :show, :id => program_motivation_types(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => program_motivation_types(:one).to_param
    assert_response :success
  end

  test "should update program_motivation_type" do
    put :update, :id => program_motivation_types(:one).to_param, :program_motivation_type => { }
    assert_redirected_to program_motivation_type_path(assigns(:program_motivation_type))
  end

  test "should destroy program_motivation_type" do
    assert_difference('ProgramMotivationType.count', -1) do
      delete :destroy, :id => program_motivation_types(:one).to_param
    end

    assert_redirected_to program_motivation_types_path
  end
end
