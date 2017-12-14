require 'test_helper'

class CacheTest < ActiveSupport::TestCase
  test 'save data' do
    Cache.create(n: 1, result: [1]);
  end
end
