class Cache < ApplicationRecord
  validates :n, allow_blank: true,
            uniqueness: true,
            numericality: true,
            inclusion: { in: 1..100 }
  serialize :result, Array
end
