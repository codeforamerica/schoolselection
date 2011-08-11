require 'test_helper'

class SchoolGroupsControllerTest < ActionController::TestCase
  setup do
    @school_group = school_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_group" do
    assert_difference('SchoolGroup.count') do
      post :create, school_group: @school_group.attributes
    end

    assert_redirected_to school_group_path(assigns(:school_group))
  end

  test "should show school_group" do
    get :show, id: @school_group.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @school_group.to_param
    assert_response :success
  end

  test "should update school_group" do
    put :update, id: @school_group.to_param, school_group: @school_group.attributes
    assert_redirected_to school_group_path(assigns(:school_group))
  end

  test "should destroy school_group" do
    assert_difference('SchoolGroup.count', -1) do
      delete :destroy, id: @school_group.to_param
    end

    assert_redirected_to school_groups_path
  end
end
