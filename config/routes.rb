Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :shipments do
      member do
        put :receive
        put :pick
      end
    end

    resources :orders do
      member do
        put :export
      end
    end
  end
end
