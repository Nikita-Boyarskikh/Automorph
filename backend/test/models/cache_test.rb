require 'test_helper'

class CacheTest < ActiveSupport::TestCase
  test 'save data' do
    assert Cache.new(n: 2, result: [1]).save
  end

  test 'check unique constraint' do
    assert !Cache.new(n: 1, result: [1]).save
  end

  test 'n must be number' do
    assert !Cache.new(n: 'string').save
  end

  test 'n must be greater then 0' do
    assert !Cache.new(n: 0).save
  end

  test 'n must be less then or equal to 100' do
    assert !Cache.new(n: 101).save
  end

  test 'load data from fixtures' do
    cache = Cache.find_by(n: 1)
    assert_equal 1, cache.n
    assert_equal [1], cache.result
    assert_nil cache.error
  end

  test 'edit data' do
    cache = Cache.find_by(n: 1)
    assert_equal 1, cache.n
    assert_equal [1], cache.result
    assert_nil cache.error
    cache.n = 3
    assert cache.save
  end

  test 'add and delete data' do
    assert Cache.new(n: 10, result: [1, 5, 6]).save
    cache = Cache.find_by(n: 10)
    assert_equal 10, cache.n
    assert_equal [1, 5, 6], cache.result
    assert_nil cache.error

    cache.destroy
    assert cache.destroyed?
  end

  test 'delete data' do
    cache = Cache.find_by(n: 1)
    cache.destroy
    assert cache.destroyed?
  end
end
