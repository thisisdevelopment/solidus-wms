Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    put '/shipments/:id/receive', to: 'shipments#receive', as: :shipment_receive
    put '/shipments/:id/pick', to: 'shipments#pick', as: :shipment_pick

    get '/orders/to_export', to: 'orders#to_export', as: :orders_to_export
    put '/orders/:id/export', to: 'orders#export', as: :order_export
  end
end
