require 'test_helper'

class AutomorphControllerTest < ActionDispatch::IntegrationTest
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