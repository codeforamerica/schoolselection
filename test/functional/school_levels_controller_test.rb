require 'test_helper'

class SchoolLevelsControllerTest < ActionController::TestCase
  setup do
    @school_level = school_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_level" do
    assert_difference('SchoolLevel.count') do
      post :create, school_level: @school_level.attributes
    end

    assert_redirected_to school_level_path(assigns(:school_level))
  end

  test "should show school_level" do
    get :show, id: @school_level.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @school_level.to_param
    assert_response :success
  end

  test "should update school_level" do
    put :update, id: @school_level.to_param, school_level: @school_level.attributes
    assert_redirected_to school_level_path(assigns(:school_level))
  end

  test "should destroy school_level" do
    assert_difference('SchoolLevel.count', -1) do
      delete :destroy, id: @school_level.to_param
    end

    assert_redirected_to school_levels_path
  end
end
