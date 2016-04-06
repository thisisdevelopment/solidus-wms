Spree::Core::Engine.routes.draw do
    resources :shipments do
      member do
        put :receive
        put :pick
      end
    end
  namespace :api, defaults: { format: 'json' } do

    get '/orders/to_export', to: 'orders#to_export', as: 'orders_to_export'

    resources :orders do
      member do
        put :export
      end
    end
  end
end
