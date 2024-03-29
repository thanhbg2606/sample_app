Rails.application.routes.draw do
  mount API::Base, at: "/"
  resources :answers
  resources :questions
  resources :posts
  resources :avatars
  resources :members
  get 'password_resets/new'
  get 'password_resets/edit'
  scope "(:locale)", locale: /en|vi/ do
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    root "static_pages#home"
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :account_activations, only: %i(edit)
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
