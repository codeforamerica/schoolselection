require 'test_helper'

class WalkZonesControllerTest < ActionController::TestCase
  setup do
    @walk_zone = walk_zones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:walk_zones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create walk_zone" do
    assert_difference('WalkZone.count') do
      post :create, walk_zone: @walk_zone.attributes
    end

    assert_redirected_to walk_zone_path(assigns(:walk_zone))
  end

  test "should show walk_zone" do
    get :show, id: @walk_zone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @walk_zone.to_param
    assert_response :success
  end

  test "should update walk_zone" do
    put :update, id: @walk_zone.to_param, walk_zone: @walk_zone.attributes
    assert_redirected_to walk_zone_path(assigns(:walk_zone))
  end

  test "should destroy walk_zone" do
    assert_difference('WalkZone.count', -1) do
      delete :destroy, id: @walk_zone.to_param
    end

    assert_redirected_to walk_zones_path
  end
end
