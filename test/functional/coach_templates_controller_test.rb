require 'test_helper'

class CoachTemplatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coach_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coach_template" do
    assert_difference('CoachTemplate.count') do
      post :create, :coach_template => { }
    end

    assert_redirected_to coach_template_path(assigns(:coach_template))
  end

  test "should show coach_template" do
    get :show, :id => coach_templates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => coach_templates(:one).to_param
    assert_response :success
  end

  test "should update coach_template" do
    put :update, :id => coach_templates(:one).to_param, :coach_template => { }
    assert_redirected_to coach_template_path(assigns(:coach_template))
  end

  test "should destroy coach_template" do
    assert_difference('CoachTemplate.count', -1) do
      delete :destroy, :id => coach_templates(:one).to_param
    end

    assert_redirected_to coach_templates_path
  end
end
