require 'test_helper'

class NonSmokingBarsControllerTest < ActionController::TestCase
  setup do
    @non_smoking_bar = non_smoking_bars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:non_smoking_bars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create non_smoking_bar" do
    assert_difference('NonSmokingBar.count') do
      post :create, non_smoking_bar: @non_smoking_bar.attributes
    end

    assert_redirected_to non_smoking_bar_path(assigns(:non_smoking_bar))
  end

  test "should show non_smoking_bar" do
    get :show, id: @non_smoking_bar.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @non_smoking_bar.to_param
    assert_response :success
  end

  test "should update non_smoking_bar" do
    put :update, id: @non_smoking_bar.to_param, non_smoking_bar: @non_smoking_bar.attributes
    assert_redirected_to non_smoking_bar_path(assigns(:non_smoking_bar))
  end

  test "should destroy non_smoking_bar" do
    assert_difference('NonSmokingBar.count', -1) do
      delete :destroy, id: @non_smoking_bar.to_param
    end

    assert_redirected_to non_smoking_bars_path
  end
end
