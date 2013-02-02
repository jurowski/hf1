require 'test_helper'

class ProgramTemplatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_template" do
    assert_difference('ProgramTemplate.count') do
      post :create, :program_template => { }
    end

    assert_redirected_to program_template_path(assigns(:program_template))
  end

  test "should show program_template" do
    get :show, :id => program_templates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => program_templates(:one).to_param
    assert_response :success
  end

  test "should update program_template" do
    put :update, :id => program_templates(:one).to_param, :program_template => { }
    assert_redirected_to program_template_path(assigns(:program_template))
  end

  test "should destroy program_template" do
    assert_difference('ProgramTemplate.count', -1) do
      delete :destroy, :id => program_templates(:one).to_param
    end

    assert_redirected_to program_templates_path
  end
end
