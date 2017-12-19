require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  protected

  def signin_as_user1
    post sessions_create_url(session: {
        nickname: users(:one).nickname,
        password: 'pass1'
    })
  end
end