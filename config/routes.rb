Rails.application.routes.draw do
  resources :feeds

  root 'feeds#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
