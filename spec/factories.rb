FactoryBot.define do
  factory :payment_amount do
    down_payment { 10_000 }
    payment_schedule  { 'monthly' }
    amortization_period { 25 }
    asking_price { 100_000 }
  end

  factory :mortgage_amount do
    payment_amount { 1_000 }
    payment_schedule  { 'monthly' }
    amortization_period { 25 }
  end
end
