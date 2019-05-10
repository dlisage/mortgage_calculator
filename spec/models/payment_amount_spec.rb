require 'rails_helper'

RSpec.describe PaymentAmount, type: :model do
  describe 'validations' do
    it 'returns error if a required field if missing' do
      payment_amount = build(:payment_amount, asking_price: '')
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?("can't be blank")).to be_truthy
    end

    it 'returns error if asking_price is negative' do
      payment_amount = build(:payment_amount, asking_price: -9)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.include?('Asking price must be greater than or equal to 0')).to be_truthy
    end

    it 'returns error if payment_schedule is not weekly, biweekly or monthly' do
      payment_amount = build(:payment_amount, payment_schedule: 'test')
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('must be one of (weekly biweekly monthly)')).to be_truthy
    end

    it 'returns error if amortization_period is less than 5' do
      payment_amount = build(:payment_amount, amortization_period: 2)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('Amortization period must be >= 5 and <= 25')).to be_truthy
    end

    it 'returns error if amortization_period is greater than 25' do
      payment_amount = build(:payment_amount, amortization_period: 60)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('Amortization period must be >= 5 and <= 25')).to be_truthy
    end

    it 'returns error if amortization_period is not an integer' do
      payment_amount = build(:payment_amount, amortization_period: 12.5)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('must be an integer')).to be_truthy
    end

    it 'returns error if down_payment less than required for asking_price is less than 500k' do
      payment_amount = build(:payment_amount, down_payment: 1000)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('Invalid downpayment')).to be_truthy
    end

    it 'returns error if down_payment less than required asking_price is greater than 500k' do
      payment_amount = build(:payment_amount, down_payment: 49999, asking_price: 750_000)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('Invalid downpayment')).to be_truthy
    end

    it 'returns error if down_payment is greater than asking price' do
      payment_amount = build(:payment_amount, down_payment: 750_001, asking_price: 750_000)
      result = payment_amount.validate
      expect(result).to be_falsey
      expect(payment_amount.errors.full_messages.to_s.include?('Invalid downpayment')).to be_truthy
    end

    it 'validates payment schedule as capital letters' do
      payment_amount = build(:payment_amount, down_payment: 750_00, asking_price: 750_000, payment_schedule: 'MONTHLY')
      result = payment_amount.validate
      expect(result).to be_truthy
    end
  end

  describe '#payment_amount' do
    it 'returns correct payment amount ' do
      payment_amount = build(:payment_amount, asking_price: 500_000, down_payment: 200_000)
      expect(payment_amount.payment_amount).to eq(BigDecimal('1345.79'))
    end
  end

  describe '#insurance_amount' do
    it 'returns 0 if asking_price is over 1 million' do
      payment_amount = build(:payment_amount, asking_price: 1000_001)
      expect(payment_amount.__send__(:insurance_amount)).to eq(BigDecimal('0'))
    end

    it 'returns 0 if down_payment/asking_price is over 20%' do
      payment_amount = build(:payment_amount, asking_price: 100_000, down_payment: 20_000)
      expect(payment_amount.__send__(:insurance_amount)).to eq(BigDecimal('0'))
    end

    it 'returns correct amount if down_payment/asking_price is 15%-19.99%' do
      payment_amount = build(:payment_amount, asking_price: 100_000, down_payment: 15_000)
      expect(payment_amount.__send__(:insurance_amount)).to eq(BigDecimal('1530'))
    end

    it 'returns correct amount if down_payment/asking_price is 10%-14.99%' do
      payment_amount = build(:payment_amount, asking_price: 100_000, down_payment: 10_000)
      expect(payment_amount.__send__(:insurance_amount)).to eq(BigDecimal('2160'))
    end

    it 'returns correct amount if down_payment/asking_price is 5%-9.99%' do
      payment_amount = build(:payment_amount, asking_price: 100_000, down_payment: 5_000)
      expect(payment_amount.__send__(:insurance_amount)).to eq(BigDecimal('2992.5'))
    end

    it 'raises error if down_payment/asking_price is less than 5%' do
      payment_amount = build(:payment_amount, asking_price: 100_000, down_payment: 3_000)
      expect { payment_amount.__send__(:insurance_amount) }.to raise_error(NotImplementedError)
    end
  end

  describe '#number_of_payment' do
    it 'return correct number of payments for monthly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'monthly', amortization_period: 5)
      expect(payment_amount.__send__(:number_of_payments)).to eq(60)
    end

    it 'return correct number of payments for biweekly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'biweekly', amortization_period: 5)
      expect(payment_amount.__send__(:number_of_payments)).to eq(130)
    end

    it 'return correct number of payments for weekly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'weekly', amortization_period: 5)
      expect(payment_amount.__send__(:number_of_payments)).to eq(260)
    end
  end

  describe '#interest_rate_by_payment_schedule' do
    it 'return correct rate for monthly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'monthly')
      expect(payment_amount.__send__(:interest_rate_by_payment_schedule)).to eq(BigDecimal('0.002083'))
    end

    it 'return correct rate for biweekly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'biweekly')
      expect(payment_amount.__send__(:interest_rate_by_payment_schedule)).to eq(BigDecimal('0.000962'))
    end

    it 'return correct rate for weekly payment schedule' do
      payment_amount = build(:payment_amount, payment_schedule: 'weekly')
      expect(payment_amount.__send__(:interest_rate_by_payment_schedule)).to eq(BigDecimal('0.000481'))
    end
  end
end
