# frozen_string_literal: true

# PaymentAmountController controller
class PaymentAmountController < ApplicationController
  def calculate
    payment_amount = build_payment_amount
    if payment_amount.validate
      render json: { payment_amount: payment_amount.payment_amount }
    else
      render json: { errors: payment_amount.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def build_payment_amount
    PaymentAmount.new(
      asking_price: params[:asking_price],
      down_payment: params[:down_payment],
      payment_schedule: params[:payment_schedule],
      amortization_period: params[:amortization_period]
    )
  end
end
