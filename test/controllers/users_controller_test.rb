require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should create" do
    post users_url
    assert_response :success
  end

  test "should get show" do
    get user_url 1
    assert_response :success
  end
  #
  # test "should get destroy" do
  #   get users_destroy_url
  #   assert_response :success
  # end
  #
  # test "should get update" do
  #   get users_update_url
  #   assert_response :success
  # end

end
