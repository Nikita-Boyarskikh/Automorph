require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  class Authorized < UsersControllerTest
    def setup
      super
      signin_as_user1
    end

    test 'should get index' do
      get users_url
      assert_template :index
      assert_response :success
    end

    test 'should show user' do
      get user_url(@user)
      assert_template :show
      assert_response :success
    end

    test 'should get edit' do
      get edit_user_url(@user)
      assert_template :edit
      assert_response :success
    end

    test 'should update user' do
      password = 'superpass'
      patch user_url(@user), params: {
          user: {
              email: @user.email,
              nickname: @user.nickname,
              password: password,
              password_confirmation: password
          }
      }

      assert_equal 'User was successfully updated.', flash[:notice]
      assert_redirected_to user_url(@user)
    end

    test 'should destroy user' do
      assert_difference('User.count', -1) do
        delete user_url(@user)
      end

      assert_redirected_to users_url
    end
  end

  class Unauthorized < UsersControllerTest
    test 'should get index' do
      get users_url
      assert_template :index
      assert_response :success
    end

    test 'should not show user' do
      get user_url(@user)
      assert_equal 'Permission denied.', flash[:alert]
      assert_redirected_to root_url
    end

    test 'should not get edit' do
      get edit_user_url(@user)
      assert_equal 'Permission denied.', flash[:alert]
      assert_redirected_to root_url
    end

    test 'should not update user' do
      password = 'superpass'
      patch user_url(@user), params: {
          user: {
              email: @user.email,
              nickname: @user.nickname,
              password: password,
              password_confirmation: password
          }
      }

      assert_equal 'Permission denied.', flash[:alert]
      assert_redirected_to root_url
    end

    test 'should not destroy user' do
      assert_no_difference('User.count') do
        delete user_url(@user)
      end

      assert_equal 'Permission denied.', flash[:alert]
      assert_redirected_to root_url
    end

    test 'should get signup' do
      get signup_url
      assert_template :new
      assert_response :success
    end

    test 'should create user' do
      assert_difference('User.count') do
        post users_url, params: {
            user: {
                email: 'e@mail.ru',
                nickname: 'nickname',
                password: 'password',
                password_confirmation: 'password'
            }
        }
      end

      assert_redirected_to user_url(User.last)
    end
  end
end
