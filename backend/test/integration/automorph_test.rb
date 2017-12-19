require 'test_helper'

class AuthomorphTest < ActionDispatch::IntegrationTest
  setup do
    signin_as_user1
  end

  test 'should get index' do
    get automorph_url
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