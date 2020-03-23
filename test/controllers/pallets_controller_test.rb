require 'test_helper'

class PalletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pallet = pallets(:one)
  end

  test "should get index" do
    get pallets_url
    assert_response :success
  end

  test "should get new" do
    get new_pallet_url
    assert_response :success
  end

  test "should create pallet" do
    assert_difference('Pallet.count') do
      post pallets_url, params: { pallet: { current_location: @pallet.current_location, destination_cc: @pallet.destination_cc, next_location: @pallet.next_location, number_of_pallets: @pallet.number_of_pallets, origin_cc: @pallet.origin_cc, vendor_code: @pallet.vendor_code } }
    end

    assert_redirected_to pallet_url(Pallet.last)
  end

  test "should show pallet" do
    get pallet_url(@pallet)
    assert_response :success
  end

  test "should get edit" do
    get edit_pallet_url(@pallet)
    assert_response :success
  end

  test "should update pallet" do
    patch pallet_url(@pallet), params: { pallet: { current_location: @pallet.current_location, destination_cc: @pallet.destination_cc, next_location: @pallet.next_location, number_of_pallets: @pallet.number_of_pallets, origin_cc: @pallet.origin_cc, vendor_code: @pallet.vendor_code } }
    assert_redirected_to pallet_url(@pallet)
  end

  test "should destroy pallet" do
    assert_difference('Pallet.count', -1) do
      delete pallet_url(@pallet)
    end

    assert_redirected_to pallets_url
  end
end
