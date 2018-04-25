require "application_system_test_case"

class CoinbagsTest < ApplicationSystemTestCase
  setup do
    @coinbag = coinbags(:one)
  end

  test "visiting the index" do
    visit coinbags_url
    assert_selector "h1", text: "Coinbags"
  end

  test "creating a Coinbag" do
    visit coinbags_url
    click_on "New Coinbag"

    fill_in "Coinbag", with: @coinbag.coinbag
    click_on "Create Coinbag"

    assert_text "Coinbag was successfully created"
    click_on "Back"
  end

  test "updating a Coinbag" do
    visit coinbags_url
    click_on "Edit", match: :first

    fill_in "Coinbag", with: @coinbag.coinbag
    click_on "Update Coinbag"

    assert_text "Coinbag was successfully updated"
    click_on "Back"
  end

  test "destroying a Coinbag" do
    visit coinbags_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coinbag was successfully destroyed"
  end
end
