# frozen_string_literal: true

# InterestRates controller
class InterestRatesController < ApplicationController
  def update
    interest_rate = InterestRate.first
    old_rate = interest_rate.interest_rate
    result = interest_rate.update_attributes(interest_rate: params[:interest_rate])
    if result
      render json: { old_rate: old_rate, new_rate: interest_rate.interest_rate }
    else
      render json: { errors: interest_rate.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

