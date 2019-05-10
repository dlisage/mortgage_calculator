# frozen_string_literal: true

# InterestRate model
class InterestRate < ApplicationRecord
  # we would like the interest rate is greater or equal to 0
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }
end
