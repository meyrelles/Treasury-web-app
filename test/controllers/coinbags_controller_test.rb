require 'test_helper'

class CoinbagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coinbag = coinbags(:one)
  end

  test "should get index" do
    get coinbags_url
    assert_response :success
  end

  test "should get new" do
    get new_coinbag_url
    assert_response :success
  end

  test "should create coinbag" do
    assert_difference('Coinbag.count') do
      post coinbags_url, params: { coinbag: { coinbag: @coinbag.coinbag } }
    end

    assert_redirected_to coinbag_url(Coinbag.last)
  end

  test "should show coinbag" do
    get coinbag_url(@coinbag)
    assert_response :success
  end

  test "should get edit" do
    get edit_coinbag_url(@coinbag)
    assert_response :success
  end

  test "should update coinbag" do
    patch coinbag_url(@coinbag), params: { coinbag: { coinbag: @coinbag.coinbag } }
    assert_redirected_to coinbag_url(@coinbag)
  end

  test "should destroy coinbag" do
    assert_difference('Coinbag.count', -1) do
      delete coinbag_url(@coinbag)
    end

    assert_redirected_to coinbags_url
  end
end
