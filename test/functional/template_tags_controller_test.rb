require 'test_helper'

class TemplateTagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_tag" do
    assert_difference('TemplateTag.count') do
      post :create, :template_tag => { }
    end

    assert_redirected_to template_tag_path(assigns(:template_tag))
  end

  test "should show template_tag" do
    get :show, :id => template_tags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => template_tags(:one).to_param
    assert_response :success
  end

  test "should update template_tag" do
    put :update, :id => template_tags(:one).to_param, :template_tag => { }
    assert_redirected_to template_tag_path(assigns(:template_tag))
  end

  test "should destroy template_tag" do
    assert_difference('TemplateTag.count', -1) do
      delete :destroy, :id => template_tags(:one).to_param
    end

    assert_redirected_to template_tags_path
  end
end
