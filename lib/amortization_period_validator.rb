# frozen_string_literal: true

# AmortizationPeriod Validator
class AmortizationPeriodValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:amortization_period] << I18n.t('errors.amortization_period') if record.amortization_period.to_i < 5 || record.amortization_period.to_i > 25
  end
end