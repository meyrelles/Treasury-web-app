require 'test_helper'

class TrStatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tr_statement = tr_statements(:one)
  end

  test "should get index" do
    get tr_statements_url
    assert_response :success
  end

  test "should get new" do
    get new_tr_statement_url
    assert_response :success
  end

  test "should create tr_statement" do
    assert_difference('TrStatement.count') do
      post tr_statements_url, params: { tr_statement: { amount: @tr_statement.amount, celebrate: @tr_statement.celebrate, coinbag: @tr_statement.coinbag, currency: @tr_statement.currency, date: @tr_statement.date, description: @tr_statement.description, from: @tr_statement.from, reason: @tr_statement.reason, systemdt: @tr_statement.systemdt, time: @tr_statement.time, timezone: @tr_statement.timezone, to: @tr_statement.to, uniqueid: @tr_statement.uniqueid } }
    end

    assert_redirected_to tr_statement_url(TrStatement.last)
  end

  test "should show tr_statement" do
    get tr_statement_url(@tr_statement)
    assert_response :success
  end

  test "should get edit" do
    get edit_tr_statement_url(@tr_statement)
    assert_response :success
  end

  test "should update tr_statement" do
    patch tr_statement_url(@tr_statement), params: { tr_statement: { amount: @tr_statement.amount, celebrate: @tr_statement.celebrate, coinbag: @tr_statement.coinbag, currency: @tr_statement.currency, date: @tr_statement.date, description: @tr_statement.description, from: @tr_statement.from, reason: @tr_statement.reason, systemdt: @tr_statement.systemdt, time: @tr_statement.time, timezone: @tr_statement.timezone, to: @tr_statement.to, uniqueid: @tr_statement.uniqueid } }
    assert_redirected_to tr_statement_url(@tr_statement)
  end

  test "should destroy tr_statement" do
    assert_difference('TrStatement.count', -1) do
      delete tr_statement_url(@tr_statement)
    end

    assert_redirected_to tr_statements_url
  end
end
