# frozen_string_literal: true

# PaymentAmount model
class PaymentAmount
  include CommonMethods

  attr_accessor :asking_price, :down_payment, :payment_schedule, :amortization_period
  validates :asking_price, :down_payment, :payment_schedule, :amortization_period, presence: true
  validates :down_payment, :asking_price, numericality: { greater_than_or_equal_to: 0 }
  validates_with DownPaymentValidator

  def payment_amount
    l = asking_price.to_d + insurance_amount - down_payment.to_d
    c = interest_rate_by_payment_schedule
    n = number_of_payments
    (l * (c * (1 + c).to_d.power(n))/((1 + c).to_d.power(n) - 1)).round(I18n.t('constants.principal_precision').to_i)
  end

  private

  def insurance_amount
    percentage = (down_payment.to_d/asking_price.to_d).round(I18n.t('constants.interest_rate_precision').to_i)
    loan = asking_price.to_d - down_payment.to_d
    return BigDecimal('0') if percentage >= BigDecimal('0.20') || asking_price.to_d > BigDecimal('1000000')
    return (loan*BigDecimal('0.018')).round(I18n.t('constants.principal_precision').to_i) if percentage >= BigDecimal('0.15')
    return (loan*BigDecimal('0.024')).round(I18n.t('constants.principal_precision').to_i) if percentage >= BigDecimal('0.10')
    return (loan*BigDecimal('0.0315')).round(I18n.t('constants.principal_precision').to_i) if percentage >= BigDecimal('0.05')

    raise(NotImplementedError, I18n.t('errors.invalid_down_payment_and_price_rate'))
  end


end
