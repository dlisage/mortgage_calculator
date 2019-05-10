# frozen_string_literal: true

# DownPayment Validator
class DownPaymentValidator < ActiveModel::Validator
  def validate(record)
    down_payment_bottom = BigDecimal('0')
    threshold = BigDecimal('500000.00')
    if record.asking_price.to_d <= threshold
      down_payment_bottom = record.asking_price.to_d*BigDecimal('0.05')
    else
      down_payment_bottom = threshold*BigDecimal('0.05') + (record.asking_price.to_d - threshold) * BigDecimal('0.10')
    end
    record.errors[:down_payment] << I18n.t('errors.down_payment') if record.down_payment.to_d < down_payment_bottom || record.down_payment.to_d > record.asking_price.to_d
  end
end
