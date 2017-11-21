require 'test_helper'

class AutomorphControllerTest < ActionDispatch::IntegrationTest
  ANSWERS = [1, 5, 6, 25, 76].freeze
  ERROR_MESSAGE = 'Enter number between 1 and 100'

  test 'should get index' do
    get automorph_index_url
    assert_response :success
    assert_select 'h1', 'Автоморфные числа'
    assert_select %(form[method="GET"][action="#{automorph_result_path}"])
    assert_select 'input[type=number][name=number]'
    assert_select 'input[type=submit]'
  end

  test 'should get result for automorph numbers less or equal then 25' do
    get automorph_result_url(number: 36)
    assert_response :success
    assert_template :result

    # Check headers
    assert_select 'table tr:first-child' do |tr|
      assert_select tr, 'th', 3
    end

    # Check rows
    assert_select 'table tr:not(:first-child)' do |rows|
      assert_equal rows.length, 4
      rows.each_with_index do |tr, i|
        assert_select tr, 'td[name=index]', (i + 1).to_s
        assert_select tr, 'td[name=value]', ANSWERS[i].to_s
        assert_select tr, 'td[name=square]', (ANSWERS[i]**2).to_s
      end
    end
  end

  test 'should get result for automorph numbers less or equal then 100' do
    get automorph_result_url(number: 100)
    assert_response :success
    assert_template :result

    # Check headers
    assert_select 'table tr:first-child' do |tr|
      assert_select tr, 'th', 3
    end

    # Check rows
    assert_select 'table tr:not(:first-child)' do |rows|
      assert_equal rows.length, 5
      rows.each_with_index do |tr, i|
        assert_select tr, 'td[name=index]', (i + 1).to_s
        assert_select tr, 'td[name=value]', ANSWERS[i].to_s
        assert_select tr, 'td[name=square]', (ANSWERS[i]**2).to_s
      end
    end
  end

  test 'should not get result for numbers greater then 100' do
    get automorph_result_url(number: 101)
    assert_response :success
    assert_template :result
    assert_select 'p#error', ERROR_MESSAGE
  end

  test 'should not get result for non-positive numbers' do
    get automorph_result_url(number: -1)
    assert_response :success
    assert_template :result
    assert_select 'p#error', ERROR_MESSAGE
  end

  test 'should not get result for non numbers params' do
    get automorph_result_url(number:  'string')
    assert_response :success
    assert_template :result
    assert_select 'p#error', ERROR_MESSAGE
  end

  test 'should not get result number param' do
    get automorph_result_url(number: nil)
    assert_response :success
    assert_template :result
    assert_select 'p#error', ERROR_MESSAGE
  end
end
