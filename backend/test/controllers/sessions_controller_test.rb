require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get signin' do
    get signin_url
    assert_template :new
    assert_response :success
  end

  test 'should can signin' do
    signin_as_user1
    assert_redirected_to users(:one)
  end

  test 'should not signin if wrong nickname/password' do
    post sessions_create_url(session: {
        nickname: 'wrongUsername',
        password: 'wrongPassword'
    })
    assert_equal 'Invalid nickname/password combination', flash[:error]
    assert_redirected_to signin_path
  end

  test 'should can signout' do
    delete signout_url
    assert_redirected_to root_url
  end
end
