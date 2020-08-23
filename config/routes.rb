Rails.application.routes.draw do
  root to: 'orders#index'
  resources :orders
  scope :api, module: 'api' do 
    resources :orders, only: :show 
  end 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
