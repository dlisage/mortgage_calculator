Rails.application.routes.draw do
  get 'payment-amount', to: 'payment_amount#calculate', constraints: { format: 'json' }
  get 'mortgage-amount', to: 'mortgage_amount#calculate', constraints: { format: 'json' }
  patch 'interest-rate', to: 'interest_rates#update', constraints: { format: 'json' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
