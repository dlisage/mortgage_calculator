require 'rails_helper'

RSpec.describe MortgageAmountController, type: :controller do
  describe '#calculate' do
    context 'with valid params' do
      let(:params) do
        {
          payment_amount: 1419.77,
          payment_schedule: 'monthly',
          amortization_period: 5
        }
      end

      it 'returns correct mortgage amount' do
        get :calculate, params: params, format: :json
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['mortgage_amount'].to_d.round(0)).to eq(80_000)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          payment_amount: 1419.77,
          payment_schedule: 'monthlytest',
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
