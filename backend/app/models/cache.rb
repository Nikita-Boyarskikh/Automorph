class Cache < ApplicationRecord
  validates :id, numericality: {
    greater_than: 0,
    less_then_or_equal_to: 100
  }, allow_blank: true
  serialize :result, Array
end
