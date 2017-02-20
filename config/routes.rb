Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'code_reviews', to: 'code_reviews#index'
  post 'code_reviews/actions', to: 'code_reviews#actions'
end
