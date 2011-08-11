require 'test_helper'

class MailClustersControllerTest < ActionController::TestCase
  setup do
    @mail_cluster = mail_clusters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_clusters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_cluster" do
    assert_difference('MailCluster.count') do
      post :create, mail_cluster: @mail_cluster.attributes
    end

    assert_redirected_to mail_cluster_path(assigns(:mail_cluster))
  end

  test "should show mail_cluster" do
    get :show, id: @mail_cluster.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mail_cluster.to_param
    assert_response :success
  end

  test "should update mail_cluster" do
    put :update, id: @mail_cluster.to_param, mail_cluster: @mail_cluster.attributes
    assert_redirected_to mail_cluster_path(assigns(:mail_cluster))
  end

  test "should destroy mail_cluster" do
    assert_difference('MailCluster.count', -1) do
      delete :destroy, id: @mail_cluster.to_param
    end

    assert_redirected_to mail_clusters_path
  end
end
