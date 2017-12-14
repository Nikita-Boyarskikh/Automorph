require 'test_helper'

class AutomorphControllerTest < ActionDispatch::IntegrationTest
  BASE_URL = 'http://localhost:3000'.freeze
  ANSWERS = [1, 5, 6, 25, 76].freeze

  # Basic tests
  class Basic < ActionDispatch::IntegrationTest
    test 'should get index' do
      get automorph_index_url
      assert_response :success
      assert_select 'h1', 'Автоморфные числа'
      assert_select 'form#input_form'
      assert_select 'input[type=number][name=number]'
      assert_select 'input[type=submit]'
    end

    test 'check rss format' do
      get automorph_result_url(number: 1, format: :rss)
      assert_response :success
      assert_includes @response.headers['Content-Type'], 'application/rss'
    end

    test 'check xml format' do
      get automorph_result_url(number: 1, format: :xml)
      assert_response :success
      assert_includes @response.headers['Content-Type'], 'application/xml'
    end
  end

  # Test AJAX
  class Ajax < ActionDispatch::IntegrationTest
    def setup
      Capybara.current_driver = :selenium_chrome
    end

    test 'should get result for automorph numbers less or equal then 25' do
      visit BASE_URL + automorph_result_path(number: 36)
      self.test_results(4)
    end

    test 'should get result for automorph numbers less or equal then 100' do
      visit BASE_URL + automorph_result_path(number: 100)
      self.test_results(5)
    end

    test 'should not get result for numbers greater then 100' do
      visit BASE_URL + automorph_result_path(number: 101)
      page.find('p#error').assert_text 'Number is too large'
    end

    test 'should not get result for non-positive numbers' do
      visit BASE_URL + automorph_result_path(number: -1)
      page.find('p#error').assert_text 'Number is too small'
    end

    test 'should not get result for non numbers params' do
      visit BASE_URL + automorph_result_path(number:  'string')
      page.find('p#error').assert_text 'Number parameter is not an integer'
    end

    test 'should not get result number param' do
      visit BASE_URL + automorph_result_path(number: nil)
      page.find('p#error').assert_text 'Number parameter is not an integer'
    end

    protected

    def test_results(length)
      # Check headers
      ths = page.find('table tr:first-child').all 'th'
      assert_equal 3, ths.length

      # Check rows
      rows = page.all 'table tr:not(:first-child)'
      assert_equal rows.length, length
      rows.each_with_index do |tr, i|
        tr.find('td[name=index]').assert_text (i + 1).to_s
        tr.find('td[name=value]').assert_text ANSWERS[i].to_s
        tr.find('td[name=square]').assert_text (ANSWERS[i]**2).to_s
      end
    end
  end

  # Without AJAX
  class Result < ActionDispatch::IntegrationTest
    test 'should get result for automorph numbers less or equal then 25' do
      get automorph_result_url(number: 36)
      assert_response :success
      assert_template :result
      self.test_results(4)
    end

    test 'should get result for automorph numbers less or equal then 100' do
      get automorph_result_url(number: 100)
      assert_response :success
      assert_template :result
      self.test_results(5)
    end

    test 'should not get result for numbers greater then 100' do
      get automorph_result_url(number: 101)
      assert_response :success
      assert_template :result
      assert_select 'p#error', 'Number is too large'
    end

    test 'should not get result for non-positive numbers' do
      get automorph_result_url(number: -1)
      assert_response :success
      assert_template :result
      assert_select 'p#error', 'Number is too small'
    end

    test 'should not get result for non numbers params' do
      get automorph_result_url(number:  'string')
      assert_response :success
      assert_template :result
      assert_select 'p#error', 'Number parameter is not an integer'
    end

    test 'should not get result number param' do
      get automorph_result_url(number: nil)
      assert_response :success
      assert_template :result
      assert_select 'p#error', 'Number parameter is not an integer'
    end

    protected

    def test_results(length)
      # Check headers
      assert_select 'table tr:first-child' do |tr|
        assert_select tr, 'th', 3
      end

      # Check rows
      assert_select 'table tr:not(:first-child)' do |rows|
        assert_equal rows.length, length
        rows.each_with_index do |tr, i|
          assert_select tr, 'td[name=index]', (i + 1).to_s
          assert_select tr, 'td[name=value]', ANSWERS[i].to_s
          assert_select tr, 'td[name=square]', (ANSWERS[i]**2).to_s
        end
      end
    end
  end
end