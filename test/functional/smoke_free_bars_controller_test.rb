require 'test_helper'

class SmokeFreeBarsControllerTest < ActionController::TestCase
  setup do
    @smoke_free_bar = smoke_free_bars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:smoke_free_bars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create smoke_free_bar" do
    assert_difference('SmokeFreeBar.count') do
      post :create, smoke_free_bar: @smoke_free_bar.attributes
    end

    assert_redirected_to smoke_free_bar_path(assigns(:smoke_free_bar))
  end

  test "should show smoke_free_bar" do
    get :show, id: @smoke_free_bar.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @smoke_free_bar.to_param
    assert_response :success
  end

  test "should update smoke_free_bar" do
    put :update, id: @smoke_free_bar.to_param, smoke_free_bar: @smoke_free_bar.attributes
    assert_redirected_to smoke_free_bar_path(assigns(:smoke_free_bar))
  end

  test "should destroy smoke_free_bar" do
    assert_difference('SmokeFreeBar.count', -1) do
      delete :destroy, id: @smoke_free_bar.to_param
    end

    assert_redirected_to smoke_free_bars_path
  end
end
