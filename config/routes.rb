Rails.application.routes.draw do
  resources :feed_members
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end
  resources :feeds do
    put 'add_member', to: 'feeds#add_member'
    delete 'remove_member', to: 'feeds#remove_member'
  end
  resources :posts


  root 'feeds#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
