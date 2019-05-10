require 'rails_helper'

RSpec.describe InterestRatesController, type: :controller do
  describe '#update' do
    context 'with valid interest rate' do
      let(:params) do
        {
          interest_rate: 0.05
        }
      end

      it 'returns correct mortgage amount' do
        patch :update, params: params, format: :json
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['new_rate'].to_d).to eq(BigDecimal('0.05'))
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          interest_rate: -1
        }
      end

      it 'returns error' do
        get :update, params: params, format: :json
        expect(response.status).to eq 422
        expect(JSON.parse(response.body)['errors'].to_s.include?('Interest rate must be greater than or equal to 0')).to be_truthy
      end
    end
  end
end
