Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :cats

  resources :cat_rental_requests

  post 'cat_rental_request/:id/approve', to: 'cat_rental_requests#approve', as: :approve
  post 'cat_rental_request/:id/deny', to: 'cat_rental_requests#deny', as: :deny
end
