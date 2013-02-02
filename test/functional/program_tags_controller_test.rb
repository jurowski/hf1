require 'test_helper'

class ProgramTagsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:program_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create program_tag" do
    assert_difference('ProgramTag.count') do
      post :create, :program_tag => { }
    end

    assert_redirected_to program_tag_path(assigns(:program_tag))
  end

  test "should show program_tag" do
    get :show, :id => program_tags(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => program_tags(:one).to_param
    assert_response :success
  end

  test "should update program_tag" do
    put :update, :id => program_tags(:one).to_param, :program_tag => { }
    assert_redirected_to program_tag_path(assigns(:program_tag))
  end

  test "should destroy program_tag" do
    assert_difference('ProgramTag.count', -1) do
      delete :destroy, :id => program_tags(:one).to_param
    end

    assert_redirected_to program_tags_path
  end
end
