require 'test_helper'

class ProgramEnrollmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_enrollments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_enrollment" do
    assert_difference('ProgramEnrollment.count') do
      post :create, :program_enrollment => { }
    end

    assert_redirected_to program_enrollment_path(assigns(:program_enrollment))
  end

  test "should show program_enrollment" do
    get :show, :id => program_enrollments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => program_enrollments(:one).to_param
    assert_response :success
  end

  test "should update program_enrollment" do
    put :update, :id => program_enrollments(:one).to_param, :program_enrollment => { }
    assert_redirected_to program_enrollment_path(assigns(:program_enrollment))
  end

  test "should destroy program_enrollment" do
    assert_difference('ProgramEnrollment.count', -1) do
      delete :destroy, :id => program_enrollments(:one).to_param
    end

    assert_redirected_to program_enrollments_path
  end
end
