require 'rails_helper'

RSpec.describe MortgageAmount, type: :model do
  describe 'validations' do
    it 'returns error if a required field if missing' do
      mortgage_amount = build(:mortgage_amount, payment_amount: nil)
      result = mortgage_amount.validate
      expect(result).to be_falsey
      expect(mortgage_amount.errors.full_messages.to_s.include?("can't be blank")).to be_truthy
    end

    it 'returns error if a payment amount is not a number' do
      mortgage_amount = build(:mortgage_amount, payment_amount: 'nonnumber')
      result = mortgage_amount.validate
      expect(result).to be_falsey
      expect(mortgage_amount.errors.full_messages.to_s.include?('is not a number')).to be_truthy
    end
  end

  describe '#mortgage_amount' do
    it 'returns correct mortgage amount without down payment ' do
      mortgage_amount = build(:mortgage_amount, payment_amount: BigDecimal('1345.79'))
      expect(mortgage_amount.mortgage_amount.to_i).to eq(BigDecimal(300_000))
    end

    it 'returns correct mortgage amount with down payment ' do
      mortgage_amount = build(:mortgage_amount, payment_amount: BigDecimal('1345.79'), down_payment: 200_000)
      expect(mortgage_amount.mortgage_amount.to_i).to eq(BigDecimal(500_000))
    end
  end
end
