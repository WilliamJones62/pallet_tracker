Rails.application.routes.draw do
  get 'pallets/ccc'
  get 'pallets/truck'
  get 'pallets/selected'
  get 'pallets/report'
  get 'pallets/chosen'
  get 'pallets/display/:id'  => 'pallets#display'
  resources :pallets
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pallets#index'
end
