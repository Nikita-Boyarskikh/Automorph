require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    Capybara.current_driver = :selenium_chrome
  end

  test 'registration' do
    assert_difference('User.count') do
      visit root_url
      click_link 'Sign up now!'

      user = {
          email: 'e@mail.ru',
          nickname: 'nickname',
          password: 'password'
      }

      fill_in 'Email', with: user[:email]
      fill_in 'Nickname', with: user[:nickname]
      fill_in 'Password', with: user[:password]
      fill_in 'Password confirmation', with: user[:password]
      click_button 'Create User'

      last_user = User.last
      assert_current_path user_path(last_user)
      assert_equal user[:email], last_user.email
      assert_equal user[:nickname], last_user.nickname
      assert last_user.authenticate(user[:password])
    end
  end

  test 'authorization' do
    assert_no_difference('User.count') do
      visit root_url
      fill_in 'Nickname', with: users(:one).nickname
      fill_in 'Password', with: 'pass1'
      click_button 'Sign in'

      assert_current_path user_path(users(:one))
    end
  end

  test 'edit password for user' do
    test_authorization
    click_on 'Edit this user'
    assert_current_path edit_user_path(users(:one))

    new_pass = 'newpass'
    fill_in 'Password', with: new_pass
    fill_in 'Password confirmation', with: new_pass
    click_on 'Update User'

    assert User.find(users(:one).id).authenticate(new_pass)
  end

  test 'edit nickname for user' do
    test_authorization
    click_on 'Edit this user'
    assert_current_path edit_user_path(users(:one))

    new_nickname = 'nickname'
    fill_in 'Nickname', with: new_nickname
    click_on 'Update User'

    assert_equal new_nickname, User.find(users(:one).id).nickname
  end

  test 'edit email for user' do
    test_authorization
    click_on 'Edit this user'
    assert_current_path edit_user_path(users(:one))

    new_email = 'email@lol.kek'
    fill_in 'Email', with: new_email
    click_on 'Update User'

    assert_equal new_email, User.find(users(:one).id).email
  end

  test 'edit all fields for user' do
    test_authorization
    click_on 'Edit this user'
    assert_current_path edit_user_path(users(:one))

    new_user = {
        email: 'e@mail.ru',
        nickname: 'nickname',
        password: 'password'
    }

    fill_in 'Nickname', with: new_user[:nickname]
    fill_in 'Email', with: new_user[:email]
    fill_in 'Password', with: new_user[:password]
    fill_in 'Password confirmation', with: new_user[:password]
    click_on 'Update User'

    assert_equal new_user[:nickname], User.find(users(:one).id).nickname
    assert_equal new_user[:email], User.find(users(:one).id).email
    assert User.find(users(:one).id).authenticate(new_user[:password])
  end

  test 'delete user' do
    assert_difference('User.count', -1) do
      test_authorization
      click_on 'Delete account'
      assert_current_path users_path
    end
  end

  test 'signout' do
    test_authorization
    click_on 'Logout'
    assert_current_path root_path
  end

  test 'show all users' do
    test_authorization
    click_on 'All users'
    assert_current_path users_path

    page.find('tbody').assert_text 'egor@life.ru	egor
N02@yandex.ru	n02'
  end

  test 'authorization and calculation' do
    test_authorization
    click_on 'Begin calculation'
    assert_current_path automorph_path

    click_button 'Найти'
    page.find('#results').assert_text '№	Квадрат числа	Число
1	1	1
2	25	5
3	36	6'
  end
end
