Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :orders do
      member do
        put :export
      end
    end
  end
end
