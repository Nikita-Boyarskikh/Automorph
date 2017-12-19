require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  protected

  def signin_as_user1
    visit signin_url
    fill_in 'Nickname', with: users(:one).nickname
    fill_in 'Password', with: 'pass1'
    click_on 'Sign in'
  end
end
