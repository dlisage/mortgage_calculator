# frozen_string_literal: true

# module CommonMethods
module CommonMethods
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  included do
    before_validation :downcase_payment_schedule
    validates :amortization_period, numericality: { only_integer: true }
    validates :payment_schedule, inclusion: { in: %w(weekly biweekly monthly), message: I18n.t('errors.payment_schedule') }
    validates_with AmortizationPeriodValidator
  end

  private

  def downcase_payment_schedule
    self.payment_schedule = payment_schedule.to_s.downcase
  end

  def number_of_payments
    return amortization_period.to_i*I18n.t('constants.weeks_per_year').to_i if payment_schedule == 'weekly'
    return amortization_period.to_i*I18n.t('constants.biweeks_per_year').to_i if payment_schedule == 'biweekly'

    # monthly
    amortization_period.to_i*I18n.t('constants.months_per_year').to_i
  end

  def interest_rate_by_payment_schedule
    precison = I18n.t('constants.interest_rate_precision').to_i
    yearly_interest_rate = InterestRate.first.interest_rate.to_d
    return (yearly_interest_rate/I18n.t('constants.weeks_per_year').to_d).round(precison) if payment_schedule == 'weekly'
    return (yearly_interest_rate/I18n.t('constants.biweeks_per_year').to_d).round(precison) if payment_schedule == 'biweekly'

    # monthly
    (yearly_interest_rate/I18n.t('constants.months_per_year').to_d).round(precison)
  end
end
