require 'rails_helper'

RSpec.describe PaymentAmountController, type: :controller do
  describe '#calculate' do
    context 'with valid params' do
      let(:params) do
        {
          down_payment: 20_000,
          asking_price: 100_000,
          payment_schedule: 'Monthly',
          amortization_period: 5
        }
      end

      it 'returns correct payment_amount' do
        get :calculate, params: params, format: :json
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['payment_amount'].to_d).to eq(BigDecimal('1419.77'))
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          down_payment: 20_000,
          asking_price: 100_000,
          payment_schedule: 'month99ly',
          amortization_period: 5
        }
      end

      it 'returns error' do
        get :calculate, params: params, format: :json
        expect(response.status).to eq 422
        expect(JSON.parse(response.body)['errors'].to_s.include?('must be one of (weekly biweekly monthly)')).to be_truthy
      end
    end
  end
end
