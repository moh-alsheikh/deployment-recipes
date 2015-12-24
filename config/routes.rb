Rails.application.routes.draw do
  resources :emps
  root to: 'emps#index'
end
