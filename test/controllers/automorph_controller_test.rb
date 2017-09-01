require 'test_helper'

class AutomorphControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get automorph_index_url
    assert_response :success
  end

  test 'should get result' do
    get automorph_result_url
    assert_response :success
  end
end
