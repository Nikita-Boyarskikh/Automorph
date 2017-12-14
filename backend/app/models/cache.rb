class Cache < ApplicationRecord
  validates :n, numericality: {
    greater_than: 0,
    less_then_or_equal_to: 100
  }, allow_blank: true
  serialize :result, Array
end
