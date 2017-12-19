require 'test_helper'

class CantCalculateWithoutLoginTest < ActionDispatch::IntegrationTest
  test 'should not get index' do
    get automorph_url
    assert_equal 'Please sign in.', flash[:notice]
    assert_redirected_to signin_path
  end

  test 'should not get result' do
    get automorph_result_url
    assert_equal 'Please sign in.', flash[:notice]
    assert_redirected_to signin_path
  end
end
