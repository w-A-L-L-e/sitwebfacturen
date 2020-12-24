Rails.application.routes.draw do
  resources :messages
  resources :invoices
  resources :invoice_lines
  resources :firms
  resources :clients
  # match ':controller(/:action(/:id))(.:format)'

  root :to=>"invoices#index"

end
