require 'test_helper'

class EventQueuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_queues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_queue" do
    assert_difference('EventQueue.count') do
      post :create, :event_queue => { }
    end

    assert_redirected_to event_queue_path(assigns(:event_queue))
  end

  test "should show event_queue" do
    get :show, :id => event_queues(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => event_queues(:one).to_param
    assert_response :success
  end

  test "should update event_queue" do
    put :update, :id => event_queues(:one).to_param, :event_queue => { }
    assert_redirected_to event_queue_path(assigns(:event_queue))
  end

  test "should destroy event_queue" do
    assert_difference('EventQueue.count', -1) do
      delete :destroy, :id => event_queues(:one).to_param
    end

    assert_redirected_to event_queues_path
  end
end
