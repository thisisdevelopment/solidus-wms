Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    put '/shipments/:id/receive', to: 'shipments#receive', as: :shipment_receive
    put '/shipments/:id/pick', to: 'shipments#pick', as: :shipment_pick

    get '/orders/to_export', to: 'orders#to_export', as: :orders_to_export
    put '/orders/:id/export', to: 'orders#export', as: :order_export
  end

  namespace :admin do
    resources :reports, only: [:index] do
      collection do
        get :unexported_orders
        post :unexported_orders
      end
    end
  end

  get '/xlsx-export/orders', to: 'orders#export_xlsx', as: :order_export_xlsx
end
