require 'test_helper'

class TemplateAchievemintsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_achievemints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_achievemint" do
    assert_difference('TemplateAchievemint.count') do
      post :create, :template_achievemint => { }
    end

    assert_redirected_to template_achievemint_path(assigns(:template_achievemint))
  end

  test "should show template_achievemint" do
    get :show, :id => template_achievemints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => template_achievemints(:one).to_param
    assert_response :success
  end

  test "should update template_achievemint" do
    put :update, :id => template_achievemints(:one).to_param, :template_achievemint => { }
    assert_redirected_to template_achievemint_path(assigns(:template_achievemint))
  end

  test "should destroy template_achievemint" do
    assert_difference('TemplateAchievemint.count', -1) do
      delete :destroy, :id => template_achievemints(:one).to_param
    end

    assert_redirected_to template_achievemints_path
  end
end
