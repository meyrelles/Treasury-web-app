require "application_system_test_case"

class TrStatementsTest < ApplicationSystemTestCase
  setup do
    @tr_statement = tr_statements(:one)
  end

  test "visiting the index" do
    visit tr_statements_url
    assert_selector "h1", text: "Tr Statements"
  end

  test "creating a Tr statement" do
    visit tr_statements_url
    click_on "New Tr Statement"

    fill_in "Amount", with: @tr_statement.amount
    fill_in "Celebrate", with: @tr_statement.celebrate
    fill_in "Coinbag", with: @tr_statement.coinbag
    fill_in "Currency", with: @tr_statement.currency
    fill_in "Date", with: @tr_statement.date
    fill_in "Description", with: @tr_statement.description
    fill_in "From", with: @tr_statement.from
    fill_in "Reason", with: @tr_statement.reason
    fill_in "Systemdt", with: @tr_statement.systemdt
    fill_in "Time", with: @tr_statement.time
    fill_in "Timezone", with: @tr_statement.timezone
    fill_in "To", with: @tr_statement.to
    fill_in "Uniqueid", with: @tr_statement.uniqueid
    click_on "Create Tr statement"

    assert_text "Tr statement was successfully created"
    click_on "Back"
  end

  test "updating a Tr statement" do
    visit tr_statements_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @tr_statement.amount
    fill_in "Celebrate", with: @tr_statement.celebrate
    fill_in "Coinbag", with: @tr_statement.coinbag
    fill_in "Currency", with: @tr_statement.currency
    fill_in "Date", with: @tr_statement.date
    fill_in "Description", with: @tr_statement.description
    fill_in "From", with: @tr_statement.from
    fill_in "Reason", with: @tr_statement.reason
    fill_in "Systemdt", with: @tr_statement.systemdt
    fill_in "Time", with: @tr_statement.time
    fill_in "Timezone", with: @tr_statement.timezone
    fill_in "To", with: @tr_statement.to
    fill_in "Uniqueid", with: @tr_statement.uniqueid
    click_on "Update Tr statement"

    assert_text "Tr statement was successfully updated"
    click_on "Back"
  end

  test "destroying a Tr statement" do
    visit tr_statements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tr statement was successfully destroyed"
  end
end
