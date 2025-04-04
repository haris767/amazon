Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :categories do
    resources :subcategories
  end

  resources :subcategories do
    resources :products
  end
  resources :buy_product

  delete "/cart", to: "buy_product#empty_cart", as: "empty_cart"

  get "/update_shipping", to: "buy_product#update_shipping"
   resources :prime_subscriptions, only: [ :create ]
   get "prime_subscriptions/success", to: "prime_subscriptions#success"

   resources :product_payments, only: [ :create ]
  get "product_payments/success", to: "product_payments#success"

  resource :profile, only: [ :edit, :update ]

  resource :email, only: [ :edit, :update ]
  resource :password, only: [ :edit, :update ]

  resources :purchases, only: [ :index ]

  resources :purchases, only: [ :index ] do
    resources :reviews, only: [ :new, :create ]
  end

  namespace :owner do
    resources :products do
      member do
        patch "update_sizes"
        patch "update_styles"
        patch "add_images"
        delete "remove_image"
      end
    end
    resources :purchases, only: :index
  end
  get "/products/:id/get_image", to: "products#get_image"
  resources :orders
  # Route to show the most recent order
  get "orders/most_recent", to: "orders#most_recent", as: :most_recent_order
end
