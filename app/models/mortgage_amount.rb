# frozen_string_literal: true

# MortgageAmount model
class MortgageAmount
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include CommonMethods
  attr_accessor :payment_amount, :down_payment, :payment_schedule, :amortization_period
  validates :payment_amount, :payment_schedule, :amortization_period, presence: true
  validates :down_payment, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :payment_amount, numericality: { greater_than_or_equal_to: 0 }

  def mortgage_amount
    c = interest_rate_by_payment_schedule
    n = number_of_payments
    p = payment_amount.to_d
    (p * ((1 + c).to_d.power(n) - 1)/(c * (1 + c).to_d.power(n)))
      .round(I18n.t('constants.principal_precision').to_i) + down_payment.to_d.round(I18n.t('constants.principal_precision').to_i)
  end
end