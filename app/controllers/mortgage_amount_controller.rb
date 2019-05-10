# frozen_string_literal: true

# MortgageAmount controller
class MortgageAmountController < ApplicationController
  def calculate
    mortgage_amount = build_mortgage_amount
    if mortgage_amount.validate
      render json: { mortgage_amount: mortgage_amount.mortgage_amount }
    else
      render json: { errors: mortgage_amount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def build_mortgage_amount
    MortgageAmount.new(
      payment_amount: params[:payment_amount],
      down_payment: params[:down_payment],
      payment_schedule: params[:payment_schedule],
      amortization_period: params[:amortization_period]
    )
  end
end
