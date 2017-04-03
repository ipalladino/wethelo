require 'test_helper'

class PlacepicturesControllerTest < ActionController::TestCase
  setup do
    @placepicture = placepictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:placepictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create placepicture" do
    assert_difference('Placepicture.count') do
      post :create, placepicture: {  }
    end

    assert_redirected_to placepicture_path(assigns(:placepicture))
  end

  test "should show placepicture" do
    get :show, id: @placepicture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @placepicture
    assert_response :success
  end

  test "should update placepicture" do
    patch :update, id: @placepicture, placepicture: {  }
    assert_redirected_to placepicture_path(assigns(:placepicture))
  end

  test "should destroy placepicture" do
    assert_difference('Placepicture.count', -1) do
      delete :destroy, id: @placepicture
    end

    assert_redirected_to placepictures_path
  end
end
