require 'test_helper'

class AssignmentZonesControllerTest < ActionController::TestCase
  setup do
    @assignment_zone = assignment_zones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_zones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_zone" do
    assert_difference('AssignmentZone.count') do
      post :create, assignment_zone: @assignment_zone.attributes
    end

    assert_redirected_to assignment_zone_path(assigns(:assignment_zone))
  end

  test "should show assignment_zone" do
    get :show, id: @assignment_zone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_zone.to_param
    assert_response :success
  end

  test "should update assignment_zone" do
    put :update, id: @assignment_zone.to_param, assignment_zone: @assignment_zone.attributes
    assert_redirected_to assignment_zone_path(assigns(:assignment_zone))
  end

  test "should destroy assignment_zone" do
    assert_difference('AssignmentZone.count', -1) do
      delete :destroy, id: @assignment_zone.to_param
    end

    assert_redirected_to assignment_zones_path
  end
end
