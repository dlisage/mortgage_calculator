# frozen_string_literal: true

# PaymentSchedule Validator
class PaymentScheduleValidator < ActiveModel::Validator
  def validate(record)
    types = %w(weekly biweekly monthly)
    record.payment_schedule = record.payment_schedule.to_s.downcase
    record.errors[:payment_schedule] << I18n.t('errors.payment_schedule') unless types.include?(record.payment_schedule)
  end
end
